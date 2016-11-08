export script_name = 'OpenCC'
export script_description = 'OpenCC for Aegisub,Conversion works on selected lines.'
export script_author = "SujiKiNen"

ok, ffi = pcall require, 'ffi'
return if not ok or jit.os != 'Windows'

opencc = ffi.load 'OpenCCopencc.dll'

ffi.cdef[[

enum{CP_UTF8 = 65001};
typedef unsigned int UINT;
typedef unsigned long DWORD;
typedef const char* LPCSTR;
typedef const wchar_t* LPCWSTR;
typedef wchar_t* LPWSTR;
int MultiByteToWideChar(UINT, DWORD, LPCSTR, int, LPWSTR, int);
typedef int INT;

typedef void* opencc_t;
opencc_t opencc_open(const char* configFileName);
opencc_t opencc_open_w(const wchar_t* configFileName);
int opencc_close(opencc_t opencc);
char* opencc_convert_utf8(opencc_t opencc,const char* input,size_t length);
void opencc_convert_utf8_free(char* str);
const char* opencc_error(void);
]]

config_file_name = {'s2t','t2s','s2tw','tw2s','s2hk','hk2s','s2twp','tw2sp','t2tw','t2hk'}

utf8_to_utf16= (s)->
	wlen = ffi.C.MultiByteToWideChar ffi.C.CP_UTF8, 0x0, s, -1, nil, 0
	ws = ffi.new "wchar_t[?]", wlen
	ffi.C.MultiByteToWideChar ffi.C.CP_UTF8, 0x0, s, -1, ws, wlen
	ws

convert_func = {}

for i=1,#config_file_name
	convert_func[i] = (subs , sel )->
		base_path = aegisub.decode_path("?user/opencc/")
		config_full_path = base_path..config_file_name[i]..".json"
		-- no check for failed to open config file name
		opencc_ptr = opencc.opencc_open_w utf8_to_utf16 config_full_path
		-- make sure the json config filename is right,otherwise the Aegisub will crash
		if opencc_ptr
			for _,i in ipairs sel 
				line = subs[i]
				ret_str_ptr = opencc.opencc_convert_utf8 opencc_ptr,line.text,string.len line.text
				line.text =  ffi.string ret_str_ptr if ret_str_ptr
				subs[i] = line
				opencc.opencc_convert_utf8_free ret_str_ptr if ret_str_ptr
			opencc.opencc_close opencc_ptr


for i=1,#config_file_name
   aegisub.register_macro script_name..'/'..config_file_name[i],script_description, convert_func[i]
