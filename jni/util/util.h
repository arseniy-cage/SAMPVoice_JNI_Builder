#pragma once

uintptr_t FindLibrary(const char* library);
void cp1251_to_utf8(char *out, const char *in, unsigned int len = 0);
char* ConvertColorToHtml(std::string format);
void AND_OpenLink(const char* szLink);
