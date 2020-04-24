A python script to generate VNC passwords. 
Thanks mixmastamyk for the source code.
http://forum.ultravnc.info/viewtopic.php?p=80709
http://www.geekademy.com/2010/10/creating-hashed-password-for-vnc.html


I've compiled this with Pyton 2.7 with p2exe. -Supercoe


NOTES:

http://www.py2exe.org/index.cgi/Tutorial

For Python 2.6, the DLL you need is called MSVCR90.dll. Py2exe is not able to automatically include this DLL in your dist directory, so you must provide it yourself.

To complicate things, there is more than one version of this DLL in existance, each with the same filename. You need the same version that the Python interpreter was compiled with, which is version 9.0.21022.8. Through the remainder of these instructions, hover your mouse over the dll file (or the vcredist_x86.exe installer executable) to confirm which version you've got.

As for older versions of Python, you need to check redist.txt within your Visual Studio installation to see whether you have the legal right to redistribute this DLL. If you do have these rights, then you have the option to bundle the C runtime DLL with you application. If you don't have the rights, then you must have your users run the redistributable C runtime installer on their machines.

