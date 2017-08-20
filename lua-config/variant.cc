#include <string>
#include <cstring>
#include <type_traits>

/** A generic value holder.
 */
class Value {
public:
  using self = Value; ///< Self reference type.
  /// Type for NIL value.
  struct nil_type {};
  /// The NIL value.
  constexpr static nil_type NIL{};

  // Type traits for supported types. Unsupported have no traits and so SFINAE away.
  // This must be public for type deduction to work but are not intended for client use.
  template <typename T> struct TRAITS {
  };
protected:
  class Probe;

  /// Base wrapper class.
  /// Internal storage is treated as an instance of this which is used to get double dispatch.
  class Wrap {
  public:
    virtual ~Wrap() {}
    ///< Double dispatch entry point. The @c probe method will be called from inside the wrapped data.
    virtual bool probe(Probe &&) { return false; }
  };

  /** Specifically typed data wrapper.
   *  This is the instantiated class in internal storage.
   */
  template < typename T > class Wrapper : public Wrap {
    T _data; ///< Wrapped data.
  public:
    Wrapper(typename TRAITS<T>::value_arg_type t);
    Wrapper(T && t);
    ~Wrapper() {}
    /// reflector for double dispatch.
    bool probe(Probe && p) override { return p.probe(_data); }
  };

  // Special NIL wrapper to represent NIL, no value, invalid, void, etc.
  struct Nil : public Wrap {
    Nil(nil_type) {}
    virtual bool probe(Probe && p) { return p.probe(); }
  };
  // Struct to get the size, presuming std::string is the largest contained type.
  struct Sizer : public Wrap { std::string _data; };

#if 0
  /* Earlier attempt at doing deduction for type properties, in particular selecting the "value" argument type.
     I've since gone with a different approach but I want to save this because the technique is likely to be useful
     elsewhere. The usage is
     f(value_arg_type<T> t); // by value or const ref, depending on T.
   */
  template <typename T> static typename std::enable_if<std::is_arithmetic<T>::value, T>::type mp_value_arg_type() {};
  template <typename T> static typename std::enable_if<!std::is_arithmetic<T>::value, T const&>::type mp_value_arg_type() {};

  template <typename T> using value_arg_type = decltype(mp_value_arg_type<T>());
#endif

  /** Internal dispatcher.
      The @c probe method is called from inside the wrapped data. Subclasses will override the particular method
      for the relevant data type.
   */
  class Probe {
  public:
    virtual bool probe() { return false; }
    virtual bool probe(std::string &) { return false; }
    virtual bool probe(int64_t &) { return false; }
    virtual bool probe(double &) { return false; }
  };

  /// Assignment.
  /// Try to update the existing wrapper, if that fails destroy it and create a new appropriately typed wrapper.
  template < typename T >
  class SetOp : public Probe {
    T const& _v;
  public:
    SetOp(typename TRAITS<T>::value_arg_type v);
    bool probe(T & data);
  };

  /// Retrieval.
  /// @return @c true if the data was retrieved and put in the constructor argument, @c false if not.
  template < typename T >
  class GetOp : public Probe {
    T & _v;
  public:
    GetOp(T & v);
    bool probe(T & data);
  };

  /// Size of internal storage.
  constexpr static size_t N = sizeof(Sizer);
  /// Wrapped data is stored here.
  char _mem[N];

public:
  /// Default constructor.
  /// Create a NIL value.
  Value() {
    new (_mem) Nil(NIL);
  }

  /// Retrieve data.
  /// @return @c true if the data was retrieved, @c false otherwise.
  template <typename T> bool get(T& v);
  // Unfortunately I couldn't get template type deduction to work so these must
  // be explicitly declared. OTOH this makes doing special handling for not explicitly
  // stored types easy. E.g., we should @c string_view as a value to get/set which uses
  // @c std::string internally.
  self& operator = (std::string const& s);
  self& operator = (int64_t v);
  self& operator = (int v);
  self& operator = (double f);
  self& operator = (nil_type n);

protected:
  // Internal method that is templated but must be used with explicit template arg, too annoying for external use.
  // It's here to all the explicit types above can just forward to this.
  template <typename T> self& assign(typename TRAITS<T>::value_arg_type v);

};

// A bit ugly but explicit template specializations must be directly in a namespace, not a class.

template <> struct Value::TRAITS<std::string> {
  using type = std::string;
  using value_arg_type = type const&;
  using wrapper_type = Value::Wrapper<type>;
};

template <> struct Value::TRAITS<int64_t> {
  using type = int64_t;
  using value_arg_type = type;
  using wrapper_type = Value::Wrapper<type>;
};

template <> struct Value::TRAITS<double> {
  using type = double;
  using value_arg_type = type;
  using wrapper_type = Value::Wrapper<type>;
};

template <> struct Value::TRAITS<Value::nil_type> {
  using type = nil_type;
  using value_arg_type = type;
  using wrapper_type = Value::Nil;
};

#if 0
template <> struct Value::TRAITS<string_view> {
  using type = string_view;
  using value_arg_type = string_view;
  using wrapper_type = Value::Wrapper<std::string>;
};
#endif

// Special handling for NIL
template <> struct Value::GetOp<Value::nil_type> : public Value::Probe {
  GetOp(nil_type) {}
  bool probe() { return true; }
};
template <> struct Value::SetOp<Value::nil_type> : public Value::Probe {
  SetOp(nil_type) {}
  bool probe() { return true; }
};

template <typename T>
Value::Wrapper<T>::Wrapper(typename TRAITS<T>::value_arg_type t) : _data(t) {}
template <typename T>
Value::Wrapper<T>::Wrapper(T && t) : _data(std::move(t)) {}

Value &Value::operator=(std::string const& s) { return this->template assign<std::string>(s); }
Value &Value::operator=(int64_t v) { return this->template assign<int64_t>(v); }
Value &Value::operator=(int v) { return this->template assign<int64_t>(v); }
Value &Value::operator=(double s) { return this->template assign<double>(s); }
Value &Value::operator=(nil_type s) { return this->template assign<nil_type>(s); }

template<typename T>
Value &Value::assign(typename TRAITS<T>::value_arg_type v) {
  Wrap& w = reinterpret_cast<Wrap&>(_mem);
  // If the type is already appropriate, the probe succeeds, updating the current value.
  // Otherwise it's the wrong type in which case the current wrapper must be destructed
  // and a new wrapper constructed in place.
  if (!w.probe(SetOp<T>(v))) {
    w.~Wrap();
    new (_mem) typename TRAITS<T>::wrapper_type(v);
  }
  return *this;
}

template <typename T>
bool Value::get(T& v) {
  return reinterpret_cast<Wrap&>(_mem).probe(GetOp<T>(v));
}

template <typename T>
Value::GetOp<T>::GetOp(T &v) : _v(v) {}

template <typename T>
bool Value::GetOp<T>::probe(T &data) { _v = data; return true; }

template <typename T>
Value::SetOp<T>::SetOp(typename TRAITS<T>::value_arg_type v) : _v(v) {}

template <typename T>
bool Value::SetOp<T>::probe(T &data) { data = _v; return true; }

#if 0
template <> Value::GetOp<string_view> : public Probe {
  string_view& _v;
  GetOp(string_view& sv) : _v(sv) {}
  bool probe(std::string& s) { _v = s; return true; }
};

template <> Value::SetOp<string_view> : public Probe {
  string_view& _v;
  SetOp(string_view& sv) : _v(sv) {}
  bool probe(std::string& s) { s.assign(_v.data(), _v.size()); return true; }
};
#endif

int main(int argc, char * argv[]) {
  Value v;
  std::string s;

  bool zret = v.get(s);
  s.assign("bob", strlen("bob"));
  v = s;
  s = "dave";
  zret = v.get(s);
  v = 17;
  int64_t x;
  zret = v.get(x);
  zret = v.get(s);
  return 0;
}
