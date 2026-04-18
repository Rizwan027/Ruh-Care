Add-Type @"
using System;
using System.Runtime.InteropServices;
public class Win32 {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern IntPtr FindWindow(string lpClassName, string lpWindowName);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);
    
    [DllImport("user32.dll")]
    public static extern bool GetWindowRect(IntPtr hwnd, ref Rect rectangle);

    public struct Rect {
        public int Left;
        public int Top;
        public int Right;
        public int Bottom;
    }
}
"@

$processes = Get-Process | Where-Object { $_.MainWindowTitle -match "Android Emulator" -or $_.ProcessName -match "qemu" }
foreach ($p in $processes) {
    if ($p.MainWindowHandle -ne [IntPtr]::Zero) {
        $hwnd = $p.MainWindowHandle
        $rect = New-Object Win32+Rect
        [Win32]::GetWindowRect($hwnd, [ref]$rect)
        $currentWidth = $rect.Right - $rect.Left
        $currentHeight = $rect.Bottom - $rect.Top
        
        $newWidth = [math]::Round($currentWidth * 0.7)
        $newHeight = [math]::Round($currentHeight * 0.7)

        [Win32]::MoveWindow($hwnd, $rect.Left, $rect.Top, $newWidth, $newHeight, $true)
        Write-Host ("Resized window for " + $p.ProcessName + " - " + $p.MainWindowTitle + " to " + $newWidth + "x" + $newHeight)
    }
}
Write-Host "Done"
