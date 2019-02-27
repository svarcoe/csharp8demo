using System;
using System.Threading.Tasks;

namespace Csharp8Demo.ConsoleApp
{
    class Program
    {
        static async Task Main(string[] args)
        {
            Console.WriteLine("Hello World!!!!");
            Console.Beep()  ;

            string s = null;

            Console.WriteLine($"Hi {s}");
        }
    }
}
