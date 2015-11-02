using OpenQA.Selenium;
using OpenQA.Selenium.Support.PageObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace YouTubeTest
{
    class HistoryClear
    {

        public HistoryClear()
        {
            PageFactory.InitElements(PropertiesCollection.driver, this);
        }

        [FindsBy(How = How.Id, Using = "watch-history-clear-confirm-button")]
        public IWebElement btnClearHistory { get; set; }



        public void ConfirmClearHistoryClick()
        {
            Console.WriteLine("Potwierdzam usunięcie historii");
            SeleniumSetMethods.Click(btnClearHistory);

        }
    }
}
