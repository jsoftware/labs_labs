// lab "DLL: writing and using a DLL"
#include <windows.h>
BOOL APIENTRY DllMain(HANDLE hInst, DWORD reason, LPVOID){ return 1;}

int val=0; char data[]="static data"; // globals

// __stdcall - windows API DLL calling convention
void	__stdcall incval(){++val;}
int		__stdcall getval(){return val;}
short	__stdcall incs(short s){return ++s;}
char	__stdcall incc(char c){return ++c;}
int		__stdcall inci(int i){return ++i;}
float	__stdcall incf(float f){return ++f;}
double	__stdcall incd(double d){return ++d;}
int		__stdcall addi(int x, int y){return x+y;} 

int		__stdcall addvi(int n, int* p){ int r=0;
	for(int i=0; i<n; ++i) r+=*p++; return r;}

void	__stdcall incvi(int n, int* p){
	for(int i=0; i<n; ++i) *p++ +=1;}

void	__stdcall incvs(int n, short* p){
	for(int i=0; i<n; ++i) *p++ +=1;}

void	__stdcall getdata(char* c) {strcpy(c,data);}
char*	__stdcall getdatap(){return data;}
void	__stdcall getdatapx(char* *p){ *p = data;}

// __cdecl - default C calling convention
// __cdecl is the alternate (+ cd flag) calling convention
int		altinci(int i){return ++i;}
