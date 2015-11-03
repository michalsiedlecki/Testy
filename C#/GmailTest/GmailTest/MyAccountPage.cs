using OpenQA.Selenium;
using OpenQA.Selenium.Support.PageObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GmailTest
{
    class MyAccountPage
    {
        public MyAccountPage()
        {
            PageFactory.InitElements(PropertiesCollection.driver, this);
        }



        [FindsBy(How = How.ClassName, Using = "OZ")]
        public IWebElement btnSecurity { get; set; }



        public void SecurityClick()
        {
            Console.WriteLine("Klikam w logowanie i bezpieczeństwo");
            SeleniumSetMethods.Click(btnSecurity);

        }
    }
}
