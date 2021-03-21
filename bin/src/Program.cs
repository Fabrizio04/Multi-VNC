using System;
using System.IO;
using System.Text;
using System.Threading;
using System.Diagnostics;
using System.ComponentModel;
using System.Security.Cryptography;
	
public class Program
{
	
	static void lineChanger(string newText, string fileName, int line_to_edit)
	{
     string[] arrLine = File.ReadAllLines(fileName);
     arrLine[line_to_edit - 1] = newText;
     File.WriteAllLines(fileName, arrLine);
	}
	
	public static byte[] ToByteArray(String HexString)
    {
        int NumberChars = HexString.Length;
        byte[] bytes = new byte[NumberChars / 2];

        for (int i = 0; i < NumberChars; i += 2)
        {
            bytes[i / 2] = Convert.ToByte(HexString.Substring(i, 2), 16);
        }

        return bytes;
    }
	
	public static string DecryptVNC(string password)
    {
        if (password.Length < 16)
        {
            return string.Empty;
        }

        byte[] key = { 23, 82, 107, 6, 35, 78, 88, 7 };
        byte[] passArr = ToByteArray(password);
        byte[] response = new byte[passArr.Length];

        // reverse the byte order
        byte[] newkey = new byte[8];
        for (int i = 0; i < 8; i++)
        {
            // revert key[i]:
            newkey[i] = (byte)(
                ((key[i] & 0x01) << 7) |
                ((key[i] & 0x02) << 5) |
                ((key[i] & 0x04) << 3) |
                ((key[i] & 0x08) << 1) |
                ((key[i] & 0x10) >> 1) |
                ((key[i] & 0x20) >> 3) |
                ((key[i] & 0x40) >> 5) |
                ((key[i] & 0x80) >> 7)
                );
        }
        key = newkey;
        // reverse the byte order

        DES des = new DESCryptoServiceProvider();
        des.Padding = PaddingMode.None;
        des.Mode = CipherMode.ECB;

        ICryptoTransform dec = des.CreateDecryptor(key, null);
        dec.TransformBlock(passArr, 0, passArr.Length, response, 0);

        return System.Text.ASCIIEncoding.ASCII.GetString(response);
    }
	
	public static string EncryptVNC(string password)
    {
        if (password.Length > 8)
        {
            password = password.Substring(0, 8);
        }
        if (password.Length < 8)
        {
            password = password.PadRight(8, '\0');
        }

        byte[] key = { 23, 82, 107, 6, 35, 78, 88, 7 };
        byte[] passArr = new ASCIIEncoding().GetBytes(password);
        byte[] response = new byte[passArr.Length];
        char[] chars = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };

        // reverse the byte order
        byte[] newkey = new byte[8];
        for (int i = 0; i < 8; i++)
        {
            // revert desKey[i]:
            newkey[i] = (byte)(
                ((key[i] & 0x01) << 7) |
                ((key[i] & 0x02) << 5) |
                ((key[i] & 0x04) << 3) |
                ((key[i] & 0x08) << 1) |
                ((key[i] & 0x10) >> 1) |
                ((key[i] & 0x20) >> 3) |
                ((key[i] & 0x40) >> 5) |
                ((key[i] & 0x80) >> 7)
                );
        }
        key = newkey;
        // reverse the byte order

        DES des = new DESCryptoServiceProvider();
        des.Padding = PaddingMode.None;
        des.Mode = CipherMode.ECB;

        ICryptoTransform enc = des.CreateEncryptor(key, null);
        enc.TransformBlock(passArr, 0, passArr.Length, response, 0);

        string hexString = String.Empty;
        for (int i = 0; i < response.Length; i++)
        {
            hexString += chars[response[i] >> 4];
            hexString += chars[response[i] & 0xf];
        }
        return hexString.Trim().ToLower();
    }
	
	static void writeFileVnc(string host, string port, string password){
		
		string userName = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments)+"\\UltraVNC\\"+host+".vnc";
		string path = @userName;
		password = EncryptVNC(password).ToUpper()+"00";
		
		using (StreamWriter sw = File.CreateText(path))
        {
            sw.WriteLine("[connection]");
            sw.WriteLine("host="+host);
            sw.WriteLine("port="+port);
			sw.WriteLine("proxyhost=");
			sw.WriteLine("proxyport=0");
			sw.WriteLine("password="+password);
			sw.WriteLine("[options]");
			sw.WriteLine("use_encoding_0=1");
			sw.WriteLine("use_encoding_1=1");
			sw.WriteLine("use_encoding_2=1");
			sw.WriteLine("use_encoding_3=0");
			sw.WriteLine("use_encoding_4=1");
			sw.WriteLine("use_encoding_5=1");
			sw.WriteLine("use_encoding_6=1");
			sw.WriteLine("use_encoding_7=1");
			sw.WriteLine("use_encoding_8=1");
			sw.WriteLine("use_encoding_9=1");
			sw.WriteLine("use_encoding_10=1");
			sw.WriteLine("use_encoding_11=0");
			sw.WriteLine("use_encoding_12=0");
			sw.WriteLine("use_encoding_13=0");
			sw.WriteLine("use_encoding_14=0");
			sw.WriteLine("use_encoding_15=0");
			sw.WriteLine("use_encoding_16=1");
			sw.WriteLine("use_encoding_17=1");
			sw.WriteLine("use_encoding_18=1");
			sw.WriteLine("use_encoding_19=1");
			sw.WriteLine("use_encoding_20=0");
			sw.WriteLine("use_encoding_21=0");
			sw.WriteLine("use_encoding_22=0");
			sw.WriteLine("use_encoding_23=0");
			sw.WriteLine("use_encoding_24=0");
			sw.WriteLine("use_encoding_25=1");
			sw.WriteLine("use_encoding_26=1");
			sw.WriteLine("use_encoding_27=1");
			sw.WriteLine("use_encoding_28=0");
			sw.WriteLine("use_encoding_29=1");
			sw.WriteLine("preferred_encoding=10");
			sw.WriteLine("viewonly=0");
			sw.WriteLine("showtoolbar=1");
			sw.WriteLine("AutoScaling=1");
			sw.WriteLine("fullscreen=0");
			sw.WriteLine("SavePos=0");
			sw.WriteLine("SaveSize=0");
			sw.WriteLine("directx=0");
			sw.WriteLine("autoDetect=0");
			sw.WriteLine("8bit=0");
			sw.WriteLine("shared=1");
			sw.WriteLine("swapmouse=0");
			sw.WriteLine("emulate3=1");
			sw.WriteLine("JapKeyboard=0");
			sw.WriteLine("disableclipboard=0");
			sw.WriteLine("Scaling=0");
			sw.WriteLine("scale_num=1");
			sw.WriteLine("scale_den=1");
			sw.WriteLine("cursorshape=1");
			sw.WriteLine("noremotecursor=0");
			sw.WriteLine("compresslevel=6");
			sw.WriteLine("quality=8");
			sw.WriteLine("ServerScale=1");
			sw.WriteLine("Reconnect=3");
			sw.WriteLine("EnableCache=0");
			sw.WriteLine("EnableZstd=1");
			sw.WriteLine("QuickOption=1");
			sw.WriteLine("UseDSMPlugin=0");
			sw.WriteLine("UseProxy=0");
			sw.WriteLine("allowMonitorSpanning=0");
			sw.WriteLine("ChangeServerRes=0");
			sw.WriteLine("extendDisplay=0");
			sw.WriteLine("showExtend=0");
			sw.WriteLine("use_virt=0");
			sw.WriteLine("useAllMonitors=0");
			sw.WriteLine("requestedWidth=0");
			sw.WriteLine("requestedHeight=0");
			sw.WriteLine("DSMPlugin=NoPlugin");
			sw.WriteLine("prefix=vnc_");
			sw.WriteLine("imageFormat=.jpeg");
			sw.WriteLine("AutoReconnect=3");
			sw.WriteLine("FileTransferTimeout=30");
			sw.WriteLine("ThrottleMouse=0");
			sw.WriteLine("KeepAliveInterval=5");
			sw.WriteLine("AutoAcceptIncoming=0");
			sw.WriteLine("AutoAcceptNoDSM=0");
			sw.WriteLine("GiiEnable=0");
			sw.WriteLine("RequireEncryption=0");
			sw.WriteLine("restricted=0");
			sw.WriteLine("nostatus=0");
			sw.WriteLine("nohotkeys=0");
			sw.WriteLine("sponsor=0");
			sw.WriteLine("PreemptiveUpdates=0");
			
			
        }	
	}
	
	static void shortCut(int desktop){
		
		string hostvnc = "";
		string portvnc = "";
		string passwordvnc = "";
		
		while (true)
		{
			Console.Clear();
			Console.Write("Hostname - Indirizzo IP: ");
			hostvnc = Console.ReadLine();
			if (hostvnc.Trim() != "")
			{
				break;
			}
		}
		
		while (true)
		{
			Console.Clear();
			Console.WriteLine("Hostname - Indirizzo IP: "+hostvnc);
			Console.Write("Porta: ");
			portvnc = Console.ReadLine();
			if (portvnc.Trim() != "")
			{
				break;
			}
		}
		
		while (true)
		{
			Console.Clear();
			Console.WriteLine("Hostname - Indirizzo IP: "+hostvnc);
			Console.WriteLine("Porta: "+portvnc);
			Console.Write("Password: ");
			passwordvnc = Console.ReadLine();
			if (passwordvnc.Trim() != "")
			{
				break;
			}
		}
		
		Console.Clear();
		Console.WriteLine("Hostname - Indirizzo IP: "+hostvnc);
		Console.WriteLine("Porta: "+portvnc);
		Console.WriteLine("Password: ********");
		Console.WriteLine("");
		
		writeFileVnc(hostvnc,portvnc,passwordvnc);
		
		Thread.Sleep(2000);
		
		string userName1 = "C:\\Users\\"+Environment.UserName+"\\Documents\\UltraVNC\\"+hostvnc+".vnc";
		string path1 = @userName1;
		
		if (!File.Exists(path1))
			Console.WriteLine("Errore nella creazione del collegamento nei preferiti\n"+userName1);
		else
			Console.WriteLine("Collegamento VNC aggiunto alla libreria");
		
		
		if(desktop == 1){
			
			using (Process process = new Process())
			{
				process.StartInfo.FileName = "cscript";
				process.StartInfo.WorkingDirectory = "./vbs";
				process.StartInfo.Arguments = "//B //Nologo shortcut.vbs "+hostvnc;
				process.StartInfo.RedirectStandardOutput = true;
				process.StartInfo.RedirectStandardError = true;
				process.StartInfo.UseShellExecute = false;
				process.StartInfo.CreateNoWindow = false;
				process.Start();
			}
			
			Thread.Sleep(2000);
			
			string userName = "C:\\Users\\"+Environment.UserName+"\\Desktop\\"+hostvnc+".lnk";
			string path = @userName;
			
			if (!File.Exists(path))
				Console.WriteLine("Errore nella creazione del collegamento sul Desktop\n"+userName);
			else
				Console.WriteLine("Collegamento VNC sul Desktop creato");
		}
		
		
		
	}
	
	public static void Main(string[] args)
	{
		Console.Title = "Multi-VNC by Fabrizio Amorelli";
		
		if (args == null || args.Length == 0){
			Console.WriteLine("Error");
		} else {
			
			string myparam = args[0];
			
			switch(myparam){
				
				case "encrypt":
				
				string password = "";
				string cur_password = "";
				
				foreach (string line in File.ReadLines("./inf/ultravnc.ini"))
				{
					if (line.Contains("passwd"))
					{
						cur_password = line;
						break;
					}
				}
				string[] words = cur_password.Split('=');
				cur_password = words[1].Remove(words[1].Length - 2);
				cur_password = DecryptVNC(cur_password);
				
				
				while (true)
				{
					Console.Clear();
					Console.WriteLine("Password corrente: "+cur_password);
					Console.Write("Imposta una nuova password per il Server VNC: ");
					password = Console.ReadLine();
					if (password.Trim() != "")
					{
						break;
					}
				}
				
				string passwordc = EncryptVNC(password);
				lineChanger("passwd="+passwordc.ToUpper()+"00","./inf/ultravnc.ini",2);
				lineChanger("passwd2="+passwordc.ToUpper()+"00","./inf/ultravnc.ini",3);
				Console.WriteLine("Password modificata");
				break;
				
				case "port":
				
				string port = "";
				string cur_port = "";
				
				foreach (string line in File.ReadLines("./inf/ultravnc.ini"))
				{
					if (line.Contains("PortNumber="))
					{
						cur_port = line;
						break;
					}
				}
				
				string[] words2 = cur_port.Split('=');
				cur_port = words2[1];
				
				while (true)
				{
					Console.Clear();
					Console.WriteLine("Porta corrente: "+cur_port);
					Console.Write("Imposta una nuova porta per il Server VNC: ");
					port = Console.ReadLine();
					if (port.Trim() != "")
					{
						break;
					}
				}
				
				lineChanger("PortNumber="+port,"./inf/ultravnc.ini",40);
				Console.WriteLine("Porta modificata");
				
				break;
				
				
				case "vncdesktop":
				shortCut(1);
				break;
				
				case "vncdocuments":
				shortCut(0);
				break;
			}
		}
		
	}
}