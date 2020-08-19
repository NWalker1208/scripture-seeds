using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace LibraryXMLEditor
{
    public partial class ElementConfig : UserControl
    {
        StudyElement element;

        public ElementConfig()
        {
            InitializeComponent();
        }

        public void SetElement(StudyElement element)
        {
            this.element = element;
            UpdateView();
        }

        private void UpdateView()
        {
            if (element is MediaElement)
                mediaButton.Checked = true;
            else if (element is TitleElement)
                titleButton.Checked = true;
            else
                textButton.Checked = true;
        }
    }
}
