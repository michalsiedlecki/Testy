using OpenQA.Selenium;
using OpenQA.Selenium.Support.PageObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GmailTest
{
    class MainPage
    {
        public MainPage()
        {
            PageFactory.InitElements(PropertiesCollection.driver, this);
        }

       

        [FindsBy(How = How.CssSelector, Using = "[href='https://www.google.pl/intl/pl/options/']")]
        public IWebElement btnOptions { get; set; }

       

        public void OptionsClick()
        {
            Console.WriteLine("Mój kanał");
            SeleniumSetMethods.Click(btnOptions);

        }
    }
}
