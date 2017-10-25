package AmbariPageObjects;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.annotations.Test;


public class LaunchInstallWizard 
{
	//declare variables
	protected WebDriver driver;
	protected WebDriverWait wait;
	
	@FindBy(css="a[class='btn btn-primary create-cluster-button ng-binding']")
	protected WebElement buttonLaunchInstallWizard;
	
	//constructor
	public LaunchInstallWizard(WebDriver driver)
	{
		this.driver=driver;
		this.wait = new WebDriverWait(driver, 180);
		this.driver.manage().window().maximize();
	}

	@Test
	public void LaunchInstallWizardProcess(String ambariurl) throws InterruptedException
	{
		//this.driver.navigate().to(ambariurl+"/#/installer/step0");
		wait.until(ExpectedConditions.elementToBeClickable(this.buttonLaunchInstallWizard));
		this.buttonLaunchInstallWizard.click();
		Thread.sleep(2000);
		System.out.println("Launch Install Wizard Step Successful");
	}
	
}
