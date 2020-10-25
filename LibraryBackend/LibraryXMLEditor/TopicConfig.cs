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
    public partial class TopicConfig : Form
    {
        Dictionary<string, uint> topicPrices;

        public TopicConfig(Dictionary<string, uint> topicPrices)
        {
            this.topicPrices = topicPrices;
            InitializeComponent();
        }

        private void UpdateView()
        {
            topicComboBox.Items.Clear();
            topicComboBox.Items.AddRange(topicPrices.Keys.ToArray());
        }

        private void TopicConfig_Load(object sender, EventArgs e)
        {
            UpdateView();

            if (topicPrices.Count > 0)
                topicComboBox.SelectedIndex = 0;
        }

        private void topicComboBox_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (topicPrices.TryGetValue(topicComboBox.SelectedItem.ToString(), out uint price))
                topicPriceBox.Value = (int)price;
        }

        private void topicPriceBox_ValueChanged(object sender, EventArgs e)
        {
            topicPrices[topicComboBox.SelectedItem.ToString()] = (uint)topicPriceBox.Value;
        }
    }
}
