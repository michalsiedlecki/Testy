using OpenQA.Selenium;
using OpenQA.Selenium.Support.PageObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace YouTubeTest
{
    class MyChannel2
    {
        public MyChannel2()
        {
            PageFactory.InitElements(PropertiesCollection.driver, this);
        }

       


        [FindsBy(How = How.XPath, Using = "//*[@id='channels - feeds - posting']/form/div[2]/button/span")]
        public IWebElement btnAdd { get; set; }
        


        public void AddMessage()
        {
            
            Console.WriteLine("Dodaje wiadomość");
            SeleniumSetMethods.Click(btnAdd);

        }
    }
}
