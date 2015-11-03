using OpenQA.Selenium;
using OpenQA.Selenium.Interactions;
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



        // [FindsBy(How = How.XPath, Using = "//div[contains(.,'Informacje osobowe')]")]
        [FindsBy(How = How.Id, Using = "i2")]
        public IWebElement btnSecurity { get; set; }



        public void SecurityClick()
        {
            /*Actions actions = new Actions(PropertiesCollection.driver);
            actions.MoveToElement(btnSecurity);
            actions.Perform();*/
            Console.WriteLine("Klikam w 'Informacje osobowe i prywatność'");
            SeleniumSetMethods.Click(btnSecurity);

        }
    }
}
