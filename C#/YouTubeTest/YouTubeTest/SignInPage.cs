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
    class SignInPage
    {
        public SignInPage()
        {
            PageFactory.InitElements(PropertiesCollection.driver, this);
        }

        [FindsBy(How = How.Id, Using = "Email")]
        public IWebElement txtLogin { get; set; }

        [FindsBy(How = How.Id, Using = "next")]
        public IWebElement btnNext { get; set; }


       



        public void SignIn()
        {
            Console.WriteLine("Wpisuje login");
            SeleniumSetMethods.EnterText(txtLogin, "konstanty.testowy@gmail.com");
            Console.WriteLine("klikam next");
            SeleniumSetMethods.Click(btnNext);
            Thread.Sleep(2000);
          
        }
    }
}
