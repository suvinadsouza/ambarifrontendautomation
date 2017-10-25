package AmbariPageObjects;

import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.annotations.Test;

public class InstallOptions {
	
	//declare variables
	protected WebDriver driver;
	protected WebDriverWait wait;
	
	@FindBy(css="textarea[id= 'host-names']")
	protected WebElement textareaHostnames;
	
	@FindBy(css="input[class= 'ember-view ember-checkbox radio-btn-provide-ssh-key']")
	protected WebElement radioSSHKeyReg;
	
	@FindBy(css="textarea[id= 'sshKey']")
	protected WebElement textareaSSHKey;
	
	@FindBy(css="input[class= 'ember-view ember-text-field']")
	protected WebElement inputSSHUser;
	
	@FindBy(css="input[class= 'ember-view ember-checkbox radio-btn-manual-reg']")
	protected WebElement radioManualReg;
	
	@FindBy(css="button[class= 'btn btn-success pull-right']")
	protected WebElement buttonNext;
	
	//constructor
	public InstallOptions(WebDriver driver)
	{
		this.driver=driver;
		this.wait = new WebDriverWait(driver, 2);
		this.driver.manage().window().maximize();
	}
	
	@Test
	public void InstallOptionsProcess(String hostnames,String SSHKey, String SSHUser) throws InterruptedException
	{
		
		//splitting a string of words into an array

			String[] searchstring_hostnames = hostnames.split(" ");
			
			wait.until(ExpectedConditions.visibilityOf(this.inputSSHUser));
			wait.until(ExpectedConditions.visibilityOf(this.radioManualReg));
			wait.until(ExpectedConditions.visibilityOf(this.radioSSHKeyReg));
			wait.until(ExpectedConditions.visibilityOf(this.textareaHostnames));
			wait.until(ExpectedConditions.visibilityOf(this.textareaSSHKey));
			
				
			for(int i=0;i<searchstring_hostnames.length;i++)
			{
						
				if(this.textareaHostnames.isEnabled())
				{
				this.textareaHostnames.sendKeys(searchstring_hostnames[i]);
				this.textareaHostnames.sendKeys(Keys.ENTER);
				}
			}
			
			//move to bottom of the page
			JavascriptExecutor jse = (JavascriptExecutor)this.driver;
		    jse.executeScript("window.scrollTo(0, document.body.scrollHeight)");
			
			if(SSHKey.isEmpty())
			{
				this.inputSSHUser.clear();
				this.inputSSHUser.sendKeys(SSHUser);
				this.radioManualReg.click();
				Thread.sleep(2000);
				this.driver.switchTo().activeElement().sendKeys(Keys.ENTER);
				this.buttonNext.click();
				Thread.sleep(2000);
				this.driver.switchTo().activeElement().sendKeys(Keys.ENTER);
				
			}
			else
			{
				this.radioSSHKeyReg.click();
				this.textareaSSHKey.sendKeys(SSHKey);
				this.inputSSHUser.clear();
				this.inputSSHUser.sendKeys(SSHUser);
			}
			
			if(this.buttonNext.isEnabled())
			{
			   this.buttonNext.click();
			   System.out.println("Install Options Step Successful");
			}
		
	}

}
