package AmbariPageObjects;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.annotations.Test;


public class GetStarted 
{
	//declare variables
	protected WebDriver driver;
	protected WebDriverWait wait;
	
	@FindBy(css= "input[id= 'cluster-name']")
	protected WebElement textClusterName;
	
	@FindBy(css= "button[class= 'btn btn-success pull-right']")
	protected WebElement buttonNext;
	
	//constructor
	public GetStarted(WebDriver driver)
	{
		this.driver=driver;
		this.wait = new WebDriverWait(driver, 180);
		this.driver.manage().window().maximize();
	}

	@Test
	public void GetStartedProcess(String clusterName)
	{
		//wait for elements to be visible and enabled
		this.wait.until(ExpectedConditions.elementToBeClickable(this.textClusterName));
		this.wait.until(ExpectedConditions.elementToBeClickable(this.buttonNext));
		
		if(this.textClusterName.isEnabled())
		{
			this.textClusterName.clear();
			this.textClusterName.sendKeys(clusterName);
		}
		
		if(this.buttonNext.isEnabled())
		{
			this.buttonNext.click();
			System.out.println("Get Started Step Successful");
		}
		
		
	}
	
}

