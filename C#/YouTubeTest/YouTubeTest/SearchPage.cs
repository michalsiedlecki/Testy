using OpenQA.Selenium;
using OpenQA.Selenium.Support.PageObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace YouTubeTest
{
    class SearchPage
    {
        public SearchPage()
        {
            PageFactory.InitElements(PropertiesCollection.driver, this);
        }

        [FindsBy(How = How.ClassName, Using = "item-section")]
        public IWebElement btnFiltr { get; set; }


        public void FiltrClick()
        {
            Console.WriteLine("Odtwarzam video z listy");
            SeleniumSetMethods.Click(btnFiltr);
        }
    }
}
