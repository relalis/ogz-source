#include <wtypes.h>
#include <iostream>

int PASCAL GunzMain(HINSTANCE, HINSTANCE, LPSTR, int);

int PASCAL WinMain(HINSTANCE this_inst, HINSTANCE prev_inst, LPSTR cmdline, int cmdshow)
{
	return GunzMain(this_inst, prev_inst, cmdline, cmdshow);
}

#if defined(__clang__)
int main(int argc, char** argv)
{
    // Build a command line string
    std::string cmdline;
    for (int i = 1; i < argc; ++i)
    {
        if (i > 1) cmdline += " ";
        cmdline += argv[i];
    }

    // Call GunzMain
return GunzMain(nullptr, nullptr, cmdline.empty() ? (LPSTR)"" : (LPSTR)cmdline.c_str(), 1);
}
#endif