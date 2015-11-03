using OpenQA.Selenium;
using OpenQA.Selenium.Support.PageObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace GmailTest
{
    class OptionsPage
    {
        public OptionsPage()
        {
            PageFactory.InitElements(PropertiesCollection.driver, this);
        }



        [FindsBy(How = How.ClassName, Using = "gb_3")]
        public IWebElement btnMyAccount { get; set; }



        public void MyAccountClick()
        {
            Console.WriteLine("Klikam w informacje o koncie");
            SeleniumSetMethods.Click(btnMyAccount);
            Thread.Sleep(3000);

        }
    }
}
