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

       


        [FindsBy(How = How.XPath, Using = "//span[contains(.,'Opublikuj')]")]
        public IWebElement btnAdd { get; set; }
        


        public void AddMessage()
        {
            
            Console.WriteLine("Dodaje wiadomość");
            SeleniumSetMethods.Click(btnAdd);

        }
    }
}
