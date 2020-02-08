#pragma once

#include <string>
#include <sstream>
#include <variant>
#include <vector>


namespace alisp
{

namespace lexer
{


enum class TokenType
{
    ID,
    STRING,
    KEYWORD,
    NUMBER,
    REAL_NUMBER,

    LEFT_BRACE,
    RIGHT_BRACE,

    LEFT_BRACKET,
    RIGHT_BRACKET,

    AMPER,
    QUOTATION_MARKS,
    QUOTE,
    BACKQUOTE,
    AT,
    COLON,
    COMMA,
    HASHTAG

};

std::string get_token_str(TokenType type);

class ALToken;
inline std::ostream& operator<<(std::ostream& os, const ALToken& x);
inline bool operator==(const ALToken &lhs, const ALToken &rhs);
inline bool operator!=(const ALToken &lhs, const ALToken &rhs);

class ALToken
{
  public:

    ALToken(TokenType type_, size_t char_n=0, size_t line=0)
        : type(type_), content(),
          line_num(line), char_num(char_n)
    {};

    template<typename T>
    ALToken(TokenType type_, T content_, size_t char_n=0, size_t line=0)
        : type(type_),
          line_num(line), char_num(char_n)

    {
        content = std::move(content_);
    }

    ALToken(const ALToken&) = default;
    ALToken(ALToken&) = default;
    ALToken &operator=(const ALToken&) = delete;
    ALToken &operator=(ALToken&&) = delete;


    template<typename T>
    T getContentAs() const
    {
        return std::get<T>(this->content);
    }

    float getReal() const
    {
        return getContentAs<float>();
    }

    int getNumber() const
    {
        return getContentAs<int>();
    }

    std::string getString() const
    {
        return getContentAs<std::string>();
    }

    std::string str() const
    {
        std::ostringstream os;
        os << *this;
        return os.str();
    };

    TokenType getType() const
    {
        return type;
    };

    size_t getLine() const
    {
        return this->line_num;
    };

    size_t getChar() const
    {
        return this->char_num;
    };


    friend inline bool operator==(const ALToken &lhs, const ALToken &rhs);
    friend inline std::ostream& operator<<(std::ostream& os, const ALToken& x);


  private:
    TokenType type;
    std::variant<int, float, std::string> content;
    size_t line_num;
    size_t char_num;

};

inline std::ostream& operator<<(std::ostream& os, const ALToken& x)
{
    os << "<Token (";
    os << get_token_str(x.getType());
    os << ") ";

    if (const auto val1 = std::get_if<0>(&x.content))
        os << *val1;

    else if (const auto val2 = std::get_if<1>(&x.content))
        os << *val2;

    else if (const auto val3 = std::get_if<2>(&x.content))
        os << *val3;

    os << ">";
    return os;
}

inline bool operator==(const ALToken &lhs, const ALToken &rhs)
{
    return lhs.getType() == rhs.getType();
}

inline bool operator!=(const ALToken &lhs, const ALToken &rhs)
{
    return lhs.getType() != rhs.getType();
}

}

struct ALObject;

namespace parser
{

class ParserBase
{

  public:

    ParserBase() = default;
    ParserBase(ParserBase&& ) = default;
    ParserBase &operator=(ParserBase&&) = delete;
    ParserBase &operator=(const ParserBase&&) = delete;
    virtual ~ParserBase() = default;

    virtual std::vector<ALObject*> parse(const std::string& input, const std::string& file_name) = 0;

    // virtual void *get_tracer_internal() = 0;

    // template<typename T>
    // T &get_tracer() noexcept
    // {
    //     return *static_cast<T*>(get_tracer_ptr());
    // }

};


}


}  // namespace alisp
