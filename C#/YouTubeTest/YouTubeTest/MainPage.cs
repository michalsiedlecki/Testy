using OpenQA.Selenium;
using OpenQA.Selenium.Support.PageObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace YouTubeTest
{
    class MainPage
    {
        public MainPage()
        {
            PageFactory.InitElements(PropertiesCollection.driver, this);
        }

        [FindsBy(How = How.ClassName, Using = "yt-uix-button-content")]
        public IWebElement btnSignIn { get; set; }

        [FindsBy(How = How.Id, Using = "masthead-search-term")]
        public IWebElement txtSearch { get; set; }

        [FindsBy(How = How.Id, Using = "search-btn")]
        public IWebElement btnSearch { get; set; }

        public void Seacrh(string SearchString)
        {
            Console.WriteLine("Wpisuje tekst, ktory chcesz wyszukac czyli "+ SearchString);
            SeleniumSetMethods.EnterText(txtSearch, SearchString);
            Console.WriteLine("Klikam przycisk Search");
            SeleniumSetMethods.Click(btnSearch);
        }

        public void SignIn()
        {
            Console.WriteLine("Klikam przycisk logowania ");
            SeleniumSetMethods.Click(btnSignIn);
        }
    }
}
