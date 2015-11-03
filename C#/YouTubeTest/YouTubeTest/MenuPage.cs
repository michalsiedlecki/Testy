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

        [FindsBy(How = How.CssSelector, Using = "[href='/channel/UCGFxzZ7fPcSijzGx_kxM_OQ']")]
        public IWebElement btnMyChannel { get; set; }

        public void HistoryClick()
        {
            Console.WriteLine("Klikam Historia");
            SeleniumSetMethods.Click(btnHistory);

        }

        public void MyChannelClick()
        {
            Console.WriteLine("Mój kanał");
            SeleniumSetMethods.Click(btnMyChannel);

        }
    }
}
