#include <windows.h>
#include <conio.h>
#define LUA_COMPAT_MODULE
#include "lua.h"
#include "lauxlib.h"

static HANDLE output;

static int GetXY(lua_State *L) {
	CONSOLE_SCREEN_BUFFER_INFO con;
	GetConsoleScreenBufferInfo(output, &con);
	lua_pushnumber(L, con.dwCursorPosition.X);
	lua_pushnumber(L, con.dwCursorPosition.Y);
	return 2;
}

static int GotoXY(lua_State *L) {
	COORD xy = {luaL_checknumber(L, 1), luaL_checknumber(L, 2)};
	SetConsoleCursorPosition(output, xy);
	return 0;
}

static int GetAttr(lua_State *L) {
	CONSOLE_SCREEN_BUFFER_INFO con;
	GetConsoleScreenBufferInfo(output, &con);
	lua_pushnumber(L, (BYTE)con.wAttributes);
	return 1;
}

static int SetAttr(lua_State *L) {
	SetConsoleTextAttribute(output, luaL_checknumber(L, 1));
	return 0;
}

static int ClrScr(lua_State *L) {
	CONSOLE_SCREEN_BUFFER_INFO con;
	GetConsoleScreenBufferInfo(output, &con);
	DWORD l;
	COORD xy = {0, 0};
	DWORD sz = con.dwSize.Y << 16 | con.dwSize.X;
	FillConsoleOutputCharacterA(output, ' ', sz, xy, &l);
	FillConsoleOutputAttribute(output, (BYTE)con.wAttributes, sz, xy, &l);
	return 0;
}

static int ReadKey(lua_State *L) {
	WORD key = _getwch();
	if (key == 0xE0)
		key = _getwch() << 8;
	lua_pushnumber(L, key);
	return 1;
}

static const luaL_Reg mainTable[] = {
	{ "getxy",    GetXY   },
	{ "gotoxy",   GotoXY  },
	{ "getattr",  GetAttr },
	{ "setattr",  SetAttr },
	{ "clrscr",   ClrScr  },
	{ "readkey",  ReadKey },
	{NULL, NULL}
};

LUALIB_API int luaopen_wincrt(lua_State *L) {
	output = GetStdHandle(STD_OUTPUT_HANDLE);
	luaL_openlib(L, "wincrt", mainTable, 0);
	return 1;
}
