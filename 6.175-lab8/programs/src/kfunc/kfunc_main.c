//--------------------------------------------------------------------------
// Main
// This function tries to call a kernel-only function

int main( int argc, char* argv[] )
{
    printStr("This message was printed with \"printStr()\".\n");
    printStr("Next this program will try to use the kernel-only \"kprintStr()\".\n");
    kprintStr("This message was printed with \"kprintStr()\".\n");
    kprintStr("There is something wrong with your processor, it should not be able to execute kernel-only functions in user mode!\n");

    return 1;

}
