using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace LibraryXMLEditor
{
    public partial class TextInput : Form
    {
        public string value;

        public TextInput(string title)
        {
            InitializeComponent();
            Text = title;
            value = null;
        }

        private void cancelButton_Click(object sender, EventArgs e)
        {
            Close();
        }

        private void doneButton_Click(object sender, EventArgs e)
        {
            value = textBox1.Text;
            Close();
        }
    }
}
