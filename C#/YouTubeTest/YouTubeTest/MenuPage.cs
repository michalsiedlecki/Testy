using OpenQA.Selenium;
using OpenQA.Selenium.Support.PageObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace YouTubeTest
{
    class MenuPage
    {
        public MenuPage()
        {
            PageFactory.InitElements(PropertiesCollection.driver, this);
        }

        [FindsBy(How = How.Id, Using = "history-guide-item")]
        public IWebElement btnHistory { get; set; }



        public void HistoryClick()
        {
            Console.WriteLine("Klikam Historia");
            SeleniumSetMethods.Click(btnHistory);

        }
    }
}
