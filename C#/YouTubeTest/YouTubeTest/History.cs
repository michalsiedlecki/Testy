using OpenQA.Selenium;
using OpenQA.Selenium.Support.PageObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace YouTubeTest
{
    class History
    {
        public History()
        {
            PageFactory.InitElements(PropertiesCollection.driver, this);
        }

        [FindsBy(How = How.Id, Using = "watch-history-clear-button")]
        public IWebElement btnClearHistory { get; set; }



        public void ClearHistoryClick()
        {
            Console.WriteLine("Czyszcze historię");
            SeleniumSetMethods.Click(btnClearHistory);

        }
    }
}
