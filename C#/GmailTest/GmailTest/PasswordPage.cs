using OpenQA.Selenium;
using OpenQA.Selenium.Support.PageObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GmailTest
{
    class PasswordPage
    {
        public PasswordPage()
        {
            PageFactory.InitElements(PropertiesCollection.driver, this);
        }


        [FindsBy(How = How.Id, Using = "Passwd")]
        public IWebElement txtPassword { get; set; }

        [FindsBy(How = How.Id, Using = "signIn")]
        public IWebElement btnSignIn { get; set; }


        public void WritePassword()
        {

            Console.WriteLine("Wpisuje hasło");
            SeleniumSetMethods.EnterText(txtPassword, "endomondo22");
            Console.WriteLine("klikam zaloguj");
            SeleniumSetMethods.Click(btnSignIn);
        }
    }
}
