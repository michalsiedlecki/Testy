using OpenQA.Selenium;
using OpenQA.Selenium.Support.PageObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace YouTubeTest
{
    class MainPageAfterLogout
    {
        public MainPageAfterLogout()
        {
            PageFactory.InitElements(PropertiesCollection.driver, this);
        }

        [FindsBy(How = How.Id, Using = "yt-masthead-account-picker")]
        public IWebElement btnSignIn { get; set; }

        [FindsBy(How = How.Id, Using = "appbar-guide-button")]
        public IWebElement btnMenu { get; set; }



        public void ProfileClick()
        {
            Console.WriteLine("Klikam w profil");
            SeleniumSetMethods.Click(btnSignIn);
            
        }

        public void MenuClick()
        {
            Console.WriteLine("Klikam w menu");
            SeleniumSetMethods.Click(btnMenu);

        }

    }
}
