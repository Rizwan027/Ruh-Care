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
        $width = $rect.Right - $rect.Left
        $height = $rect.Bottom - $rect.Top
        
        # Move to X=500, Y=100 so it sits beside the IDE (often IDE is on the left)
        [Win32]::MoveWindow($hwnd, 500, 100, $width, $height, $true)
        Write-Host ("Moved window for " + $p.ProcessName + " - " + $p.MainWindowTitle)
    }
}
Write-Host "Done"
