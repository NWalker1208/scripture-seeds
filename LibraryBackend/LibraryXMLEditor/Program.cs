using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace LibraryXMLEditor
{
    static class Util
    {
        // Will copy val to var if the values are different.
        // Returns true if var was changed, otherwise returns false.
        public static bool TrySet<T>(ref T var, T val)
        {
            if (!var.Equals(val))
            {
                var = val;
                return true;
            }

            return false;
        }
    }

    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new Editor("test.xml"));
        }
    }
}
