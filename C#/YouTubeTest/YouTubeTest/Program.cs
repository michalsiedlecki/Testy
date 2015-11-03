using NUnit.Framework;
using OpenQA.Selenium;
using OpenQA.Selenium.Chrome;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace YouTubeTest
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
            PropertiesCollection.driver.Navigate().GoToUrl("https://www.youtube.com/");
            Console.WriteLine("open page");
        }
        [Test]
        public void FindAndPlay()
        {

            MainPage mainPage = new MainPage();
            mainPage.SignIn();
            SignInPage signInPage = new SignInPage();
            signInPage.SignIn();
            PasswordPage passwordPage = new PasswordPage();
            passwordPage.WritePassword();
            mainPage.Seacrh("piosenka");
            SearchPage searchPage = new SearchPage();
            searchPage.FiltrClick();
        }
        [Test]
        public void LogOut()
        {

            MainPage mainPage = new MainPage();
            mainPage.SignIn();
            SignInPage signInPage = new SignInPage();
            signInPage.SignIn();
            PasswordPage passwordPage = new PasswordPage();
            passwordPage.WritePassword();
            MainPageAfterLogout mainPageAfterLogout = new MainPageAfterLogout();
            mainPageAfterLogout.ProfileClick();
            NavigationPage navigationPage = new NavigationPage();
            navigationPage.LogoutClick();

        }
        [Test]
        public void History()
        {

            MainPage mainPage = new MainPage();
            mainPage.SignIn();
            SignInPage signInPage = new SignInPage();
            signInPage.SignIn();
            PasswordPage passwordPage = new PasswordPage();
            passwordPage.WritePassword();
            MainPageAfterLogout mainPageAfterLogout = new MainPageAfterLogout();
            mainPageAfterLogout.MenuClick();
            MenuPage menuPage = new MenuPage();
            menuPage.HistoryClick();
            History history = new History();
            history.ClearHistoryClick();
            HistoryClear historyClear = new HistoryClear();
            historyClear.ConfirmClearHistoryClick();
           

        }

        [Test]
        public void AddActivity()
        {

            MainPage mainPage = new MainPage();
            mainPage.SignIn();
            SignInPage signInPage = new SignInPage();
            signInPage.SignIn();
            PasswordPage passwordPage = new PasswordPage();
            passwordPage.WritePassword();
            MainPageAfterLogout mainPageAfterLogout = new MainPageAfterLogout();
            mainPageAfterLogout.MenuClick();
            MenuPage menuPage = new MenuPage();
            menuPage.MyChannelClick();
            MyChannel myChannel = new MyChannel();
            myChannel.AddMessage("new activity");
            MyChannel2 myChannel2 = new MyChannel2();
            myChannel2.AddMessage();


        }



         [TearDown]
        public void CleanUp()
        {
            PropertiesCollection.driver.Close();
            Console.WriteLine("Close page ");
        }
    }
}
