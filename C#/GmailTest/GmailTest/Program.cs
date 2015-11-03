using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace GmailTest
{
    class Program
    {
        static void Main(string[] args)
        {
        }

        [SetUp]
        public void Initialize()
        {
            PropertiesCollection.driver = new ChromeDriver(@"C:\Users\user\Downloads");
            PropertiesCollection.driver.Navigate().GoToUrl("https://www.gmail.com/");
            
            Console.WriteLine("open page");
        }
        [Test]
        public void AccountInformation()
        {

            
            SignInPage signInPage = new SignInPage();
            signInPage.SignIn();
            PasswordPage passwordPage = new PasswordPage();
            passwordPage.WritePassword();
            MainPage mainPage = new MainPage();
            mainPage.OptionsClick();
            OptionsPage optionsPage = new OptionsPage();
            optionsPage.MyAccountClick();
            //if you want to switch back to your first window
            // driver.SwitchTo().Window(driver.WindowHandles.First());

            //switch to new window.
            PropertiesCollection.driver.SwitchTo().Window(PropertiesCollection.driver.WindowHandles.Last());

            MyAccountPage myAccountPage = new MyAccountPage();
            myAccountPage.SecurityClick();
            
        }
        


       /* [TearDown]
        public void CleanUp()
        {
            PropertiesCollection.driver.Close();
            Console.WriteLine("Close page ");
        }*/
    }

}
