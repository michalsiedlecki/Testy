using OpenQA.Selenium;
using OpenQA.Selenium.Support.PageObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace YouTubeTest
{
    class NavigationPage
    {
        public NavigationPage()
        {
            PageFactory.InitElements(PropertiesCollection.driver, this);
        }

        [FindsBy(How = How.CssSelector, Using = "[href*='/logout']")]
        public IWebElement btnLogout { get; set; }



        public void LogoutClick()
        {
            Console.WriteLine("Klikam wyloguj");
            SeleniumSetMethods.Click(btnLogout);

        }
    }
}
