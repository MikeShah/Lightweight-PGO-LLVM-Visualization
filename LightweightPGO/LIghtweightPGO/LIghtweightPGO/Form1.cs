using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;


namespace LightweightPGO
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void buttonRunQuery_Click(object sender, EventArgs e)
        {
            // Update this to get all of the queries
            string query = "SELECT " + comboBoxGranularity.Text +
                           " WHERE " + comboBoxOptions.Text +
                            " " + comboBoxTest.Text +
                            " " + textBoxValue.Text;

            textBoxQuery.Text = query;
        }

        /// <summary>
        /// Allow the developer to manually change the query.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void checkBoxManuelQuery_CheckedChanged(object sender, EventArgs e)
        {
            textBoxQuery.Enabled = checkBoxManuelQuery.Checked;
        }

        /// <summary>
        /// Terminate the application
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void exitToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

    }
}
