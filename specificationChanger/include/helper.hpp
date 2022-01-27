#include <string>

using namespace std;

//const char* whitespaces = " \t\n\r\f\v";

// trim from end of string (right)
string& rtrim(string& s, const char* t);

// trim from beginning of string (left)
string& ltrim(string& s, const char* t);

// trim from both ends of string (right then left)
string& trim(string& s, const char* t);