package AmbariPageObjects;

import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.Keys;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.interactions.Actions;
import org.openqa.selenium.support.FindBy;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.annotations.Test;

public class CustomizeServices {
	
	//declare variables
	protected WebDriver driver;
	protected WebDriverWait wait;
	protected Actions mouseActions;
	protected JavascriptExecutor jse;
	
	@FindBy(css="textarea[class='ember-view ember-text-area directories service-config-dfs-namenode-name-dir-hdfs-site-xml-default span12']")
	protected WebElement nameNodeDirs;
	
	@FindBy(css="textarea[class='ember-view ember-text-area directories service-config-dfs-datanode-data-dir-hdfs-site-xml-default span12']")
	protected WebElement dataNodeDirs;
	
	@FindBy(css="a[href='#HIVE']")
	protected WebElement linkHiveTab;
	
	@FindBy(css="a[data-target='.HIVE_advanced']")
	protected WebElement hiveAdvancedTab;
	
	@FindBy(css="a[href='#OOZIE']")
	protected WebElement linkOozieTab;
	
	@FindBy(css="a[href='#AMBARI_METRICS']")
	protected WebElement ambariMetricsTab;
	
	@FindBy(css="a[href='#KNOX']")
	protected WebElement knoxTab;
	
	@FindBy(css="a[href='#SMARTSENSE']")
	protected WebElement smartSenseTab;
	
	@FindBy(css="a[data-target='.SMARTSENSE_activity']")
	protected WebElement smartSenseactivityTab;
	
	@FindBy(css="a[href='#MISC']")
	protected WebElement miscTab;
	
	@FindBy(css="span[class='button-checkbox bootstrap-checkbox ember-view ember-checkbox service-config-ignore_groupsusers_create-cluster-env-xml-default']")
	protected WebElement checkboxSkipGroupMods;
	
	@FindBy(css="input[placeholder='Type password']")
	protected WebElement inputPassword;
		
	@FindBy(css="input[placeholder= 'Retype Password']")
	protected WebElement inputRetypePassword;
	
	@FindBy(css="button[class= 'btn btn-success']")
	protected WebElement buttonNext;
	
	//constructor
	public CustomizeServices(WebDriver driver)
	{
		this.driver=driver;
		this.wait = new WebDriverWait(driver, 180);
		this.mouseActions = new Actions(this.driver);
		this.jse = (JavascriptExecutor)this.driver;
		this.driver.manage().window().maximize();
	}
	
	@Test
	public void CustomizeServicesProcessHDFS(String namenodeDirs,  String datanodeDirs) throws InterruptedException
	{
				
		if(namenodeDirs.isEmpty())
		{
			Thread.sleep(5000);
			this.wait.until(ExpectedConditions.visibilityOf(this.nameNodeDirs));
			this.nameNodeDirs.clear();
			this.nameNodeDirs.sendKeys("/hadoop/hdfs/namenode");
		}
		else
		{   
			Thread.sleep(5000);
			this.wait.until(ExpectedConditions.visibilityOf(this.nameNodeDirs));
			this.nameNodeDirs.clear();
			this.nameNodeDirs.sendKeys(namenodeDirs);
		}
		
		if(datanodeDirs.isEmpty())
		{
			Thread.sleep(5000);
			//this.driver.findElement(By.xpath("//html/body/div/div/div/div/div[2]/div/div/div/div/div/div/div/div[2]/div/div/div/div[2]/div[1]/div/div[2]/div[1]/div/div/table/tbody/tr/td[2]/table/tbody/tr/td/div/div/div[1]/div/div[2]/textarea")).clear();
			//this.driver.findElement(By.xpath("//html/body/div/div/div/div/div[2]/div/div/div/div/div/div/div/div[2]/div/div/div/div[2]/div[1]/div/div[2]/div[1]/div/div/table/tbody/tr/td[2]/table/tbody/tr/td/div/div/div[1]/div/div[2]/textarea")).sendKeys("/hadoop/hdfs/data");
			this.wait.until(ExpectedConditions.visibilityOf(this.dataNodeDirs));
			this.dataNodeDirs.clear();
			this.dataNodeDirs.sendKeys("/hadoop/hdfs/data");
		}
		else
		{
			Thread.sleep(5000);
			//this.driver.findElement(By.xpath("//html/body/div/div/div/div/div[2]/div/div/div/div/div/div/div/div[2]/div/div/div/div[2]/div[1]/div/div[2]/div[1]/div/div/table/tbody/tr/td[2]/table/tbody/tr/td/div/div/div[1]/div/div[2]/textarea")).clear();
			//this.driver.findElement(By.xpath("//html/body/div/div/div/div/div[2]/div/div/div/div/div/div/div/div[2]/div/div/div/div[2]/div[1]/div/div[2]/div[1]/div/div/table/tbody/tr/td[2]/table/tbody/tr/td/div/div/div[1]/div/div[2]/textarea")).sendKeys(datanodeDirs);
			this.wait.until(ExpectedConditions.visibilityOf(this.dataNodeDirs));
			this.dataNodeDirs.clear();
			this.dataNodeDirs.sendKeys(datanodeDirs);
		}
	}
		
	public void CustomizeServicesProcessHive(String hivePassword) throws InterruptedException
	{
		Thread.sleep(2000);
		this.wait.until(ExpectedConditions.elementToBeClickable(this.linkHiveTab));
		this.linkHiveTab.click();
		this.wait.until(ExpectedConditions.elementToBeClickable(this.hiveAdvancedTab));
		this.hiveAdvancedTab.click();
		this.inputPassword.clear();
		this.inputRetypePassword.clear();
		this.inputPassword.sendKeys(hivePassword.toString());
		this.inputRetypePassword.sendKeys(hivePassword.toString());
	}
	
	public void CustomizeServicesProcessOOzie(String ooziePassword) throws InterruptedException
	{
		Thread.sleep(2000);
		this.jse.executeScript("window.scrollTo(0, 0)");
		this.wait.until(ExpectedConditions.elementToBeClickable(this.linkOozieTab));
		this.linkOozieTab.click();
		this.wait.until(ExpectedConditions.elementToBeClickable(this.inputPassword));
		this.wait.until(ExpectedConditions.elementToBeClickable(this.inputRetypePassword));
		this.inputPassword.clear();
		this.inputRetypePassword.clear();
		this.inputPassword.sendKeys(ooziePassword.toString());
		this.inputRetypePassword.sendKeys(ooziePassword.toString());
	}
	
	public void CustomizeServicesProcessAmbariMetrics(String grafnaPassword) throws InterruptedException
	{
		Thread.sleep(2000);
		this.jse.executeScript("window.scrollTo(0, 0)");
		this.wait.until(ExpectedConditions.elementToBeClickable(this.ambariMetricsTab));
		this.ambariMetricsTab.click();
		this.wait.until(ExpectedConditions.elementToBeClickable(this.inputPassword));
		this.wait.until(ExpectedConditions.elementToBeClickable(this.inputRetypePassword));
		this.inputPassword.clear();
		this.inputRetypePassword.clear();
		this.inputPassword.sendKeys(grafnaPassword.toString());
		this.inputRetypePassword.sendKeys(grafnaPassword.toString());
	}
	
	public void CustomizeServicesProcessKnox(String knoxmasterPassword) throws InterruptedException
	{
		Thread.sleep(2000);
		this.jse.executeScript("window.scrollTo(0, 0)");
		this.wait.until(ExpectedConditions.elementToBeClickable(this.knoxTab));
		this.knoxTab.click();
		this.wait.until(ExpectedConditions.elementToBeClickable(this.inputPassword));
		this.wait.until(ExpectedConditions.elementToBeClickable(this.inputRetypePassword));
		this.inputPassword.clear();
		this.inputRetypePassword.clear();
		this.inputPassword.sendKeys(knoxmasterPassword.toString());
		this.inputRetypePassword.sendKeys(knoxmasterPassword.toString());
	}
	
	public void CustomizeServicesProcessSmartSense(String activityanalysisPassword) throws InterruptedException
	{
		Thread.sleep(2000);
		this.jse.executeScript("window.scrollTo(0, 0)");
		this.wait.until(ExpectedConditions.elementToBeClickable(this.smartSenseTab));
		this.smartSenseTab.click();
		Thread.sleep(2000);
		this.wait.until(ExpectedConditions.elementToBeClickable(this.smartSenseactivityTab));
		this.smartSenseactivityTab.click();
		this.wait.until(ExpectedConditions.elementToBeClickable(this.inputPassword));
		this.wait.until(ExpectedConditions.elementToBeClickable(this.inputRetypePassword));
		this.inputPassword.clear();
		this.inputRetypePassword.clear();
		this.inputPassword.sendKeys(activityanalysisPassword.toString());
		this.inputRetypePassword.sendKeys(activityanalysisPassword.toString());
	}
	
	public void CustomizeServicesProcessMisc(String ldap) throws InterruptedException
	{
		Thread.sleep(2000);
		this.jse.executeScript("window.scrollTo(0, 0)");
		this.wait.until(ExpectedConditions.elementToBeClickable(this.miscTab));
		this.miscTab.click();
		Thread.sleep(2000);
		if(ldap.equals("ldap"))
		{
			/*List<WebElement> labels = this.driver.findElements(By.cssSelector("label[class='control-label']"));
					
			
			for(WebElement e: labels) 
			{		  
				  				  				  
				  if(e.getText().equals("Skip group modifications during install"))
				  {
					  System.out.println(e.getText());
					  this.jse.executeScript("arguments[0].scrollIntoView();", e);
					  mouseActions.moveToElement(e).click().perform();
					  this.driver.findElement(By.tagName("body")).sendKeys(Keys.TAB);
					  this.driver.switchTo().activeElement();
					  Thread.sleep(1000);
					  mouseActions.click().perform();
					  break;
				  }
				  
			}*/
			
			this.jse.executeScript("arguments[0].scrollIntoView();", this.checkboxSkipGroupMods);
			this.wait.until(ExpectedConditions.elementToBeClickable(this.checkboxSkipGroupMods));
			mouseActions.moveToElement(this.checkboxSkipGroupMods.findElement(By.cssSelector("button[class='btn clearfix btn-link btn-large']"))).click().perform();
			
		}
	}
	
	public void CustomizeServicesCompleteProcess() throws InterruptedException
	{
		Thread.sleep(2000);
		this.jse.executeScript("window.scrollTo(0, 0)");
		this.jse.executeScript("window.scrollTo(0, document.body.scrollHeight)");
		this.wait.until(ExpectedConditions.elementToBeClickable(this.buttonNext));
		
		this.buttonNext.click();
		//switching to a window pop up
		Thread.sleep(8000);
		this.driver.switchTo().activeElement();
		mouseActions.sendKeys(Keys.TAB).perform();
		this.driver.findElement(By.tagName("body")).sendKeys(Keys.ENTER);
		Thread.sleep(2000);
		System.out.println("Customize Services Step Successful");	
			
		
	}
		
}
