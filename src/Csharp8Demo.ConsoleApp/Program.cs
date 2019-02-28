using System;
using System.Threading.Tasks;

namespace Csharp8Demo.ConsoleApp
{
    class Program
    {
        static async Task Main(string[] args)
        {
            Console.WriteLine("Hello World!!!!");
            Console.Beep();

            string s = null;

            Console.WriteLine($"Hi {s}");

            if (true)
            {
                Console.WriteLine("It's true");
            }

            NewMethod("test");
        }

        static Program()
        {
            throw new Exception();
        }

        private static void NewMethod(string myname)
        {
            string val = "myname";
            Console.WriteLine(val);
        }
    }
}
