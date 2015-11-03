using OpenQA.Selenium;
using OpenQA.Selenium.Support.PageObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace YouTubeTest
{
    class MyChannel
    {
        public MyChannel()
        {
            PageFactory.InitElements(PropertiesCollection.driver, this);
        }

        [FindsBy(How = How.Name, Using = "message")]
        public IWebElement txtMessage { get; set; }


      


        public void AddMessage(string message)
        {
            Console.WriteLine("Wprowadzam wiadomość");
            SeleniumSetMethods.EnterText(txtMessage, message);
            SeleniumSetMethods.Click(txtMessage);
            Thread.Sleep(3000);
            

        }
    }
}
