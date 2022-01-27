#include "../include/helper.hpp"

//const char* whitespaces = " \t\n\r\f\v";

// trim from end of string (right)
string& rtrim(string& s, const char* t)
{
    s.erase(s.find_last_not_of(t) + 1);
    return s;
}

// trim from beginning of string (left)
string& ltrim(string& s, const char* t)
{
    s.erase(0, s.find_first_not_of(t));
    return s;
}

// trim from both ends of string (right then left)
string& trim(string& s, const char* t)
{
    return ltrim(rtrim(s, t), t);
}