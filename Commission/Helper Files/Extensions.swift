//
//  Extensions.swift
//  Commission
//
//  Created by Kevin Green on 4/23/21.
//

import SwiftUI


enum DecimalPlace: Int {
    case ones = 1
    case tens = 10
    case hundreds = 100
    case thousands = 1000
    case tenThousands = 10000
}


// MARK: Float Extension
extension Float {
    
    func asDecimal(by place: DecimalPlace) -> Float {
        return self / Float(place.rawValue)
    }
    
    func asDecimalFromContext() -> Float {
        var decimal: Float = 0.0
        switch self {
        case 0...9:
            decimal = self / 10
        case 10...99:
            decimal = self / 100
        case 100...999:
            decimal = self / 1000
        case 1000...9999:
            decimal = self / 10000
        case 10000...99999:
            decimal = self / 100000
        default:
            break
        }
        
        return decimal
    }
    
    func roundTo(decimal places: Int) -> Float {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = places
        formatter.minimumFractionDigits = places
        let numStr = formatter.string(from: NSNumber(value: self))
        return Float(numStr!)!
    }
    
    
}

// MARK: Double Extension
extension Double {
    enum TypeOfFormat {
        case numerical
        case currency
        case percentage
    }
   
    func formated(type: TypeOfFormat) -> String {
        let formatter = NumberFormatter()
        switch type {
        case .numerical:
            formatter.locale = Locale.current
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 2
        case .currency:
            formatter.locale = Locale.current
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 2
            formatter.currencySymbol = Locale.current.currencySymbol
        case .percentage:
            formatter.locale = Locale.current
            formatter.numberStyle = .percent
            return formatter.string(from: NSNumber(value: self)) ?? "??"
        }
        
        return formatter.string(from: NSNumber(value: self / 0.1)) ?? "??"
    }
    
    
    
    
    func asDecimal(by place: DecimalPlace) -> Double {
        return self / Double(place.rawValue)
    }
    
    func asDecimalFromContext() -> Double {
        var decimal: Double = 0.0
        switch self {
        case 0...9:
            decimal = self / 10
        case 10...99:
            decimal = self / 100
        case 100...999:
            decimal = self / 1000
        case 1000...9999:
            decimal = self / 10000
        case 10000...99999:
            decimal = self / 100000
        default:
            break
        }
        
        return decimal
    }
}



// MARK: CGFloat Extension
extension CGFloat {
    
    func asDecimal(by place: DecimalPlace) -> CGFloat {
        return self / CGFloat(place.rawValue)
    }
    
    func asDecimalFromContext() -> CGFloat {
        var decimal: CGFloat = 0.0
        switch self {
        case 0...9:
            decimal = self / 10
        case 10...99:
            decimal = self / 100
        case 100...999:
            decimal = self / 1000
        case 1000...9999:
            decimal = self / 10000
        case 10000...99999:
            decimal = self / 100000
        default:
            break
        }
        
        return decimal
    }
}








// MARK: String Extension
extension String {
    
    enum TypeOfFormat {
        case currency
        case percentage
    }
    
    /// Converts a number string to a Float.
    /// - Parameters:
    ///   - format: A TypeOfFormat to convert to.
    /// - Returns: A Float or nil.
    mutating func convertToFloat(format: TypeOfFormat) -> Float? {
        if self.first == "$" { self = String(self.dropFirst()) }
        if self.last == "%" { self = String(self.dropLast()) }
        guard let strAsFloat = Float(self) else { return nil }
        var formattedStr = ""
        switch format {
        case .currency:
            formattedStr = String(format: "%.2f", strAsFloat)
        case .percentage:
            formattedStr = String(format: "%.1f", strAsFloat)
        }
        
        if let number = Float(formattedStr) {
            return number
        }
        return nil
    }
    
    
    enum KGDateFormatType: String {
        case MM_dd_yy = "MM/dd/yy"
    }
    
    /// Converts a date string  to a date object.
    /// - Parameter str: The string of format (MM/dd/yy) to convert.
    /// - Returns: A date object or nil.
    func convertToDate(format: KGDateFormatType) -> Date? {
        let dateFormat = self //"2016-04-14T10:44:00+0000"
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current // Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = format.rawValue
        
        guard let date = dateFormatter.date(from: dateFormat) else { return nil }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        
        let finalDate = calendar.date(from: components)
        return finalDate
    }
}


// MARK: Date Extension
extension Date {
    
    public var elapsedTimeStamp: String {
//        let today = Date()
        let formatter = DateFormatter()
//        let calendar = formatter.calendar
//        let days = calendar?.dateComponents([.day], from: self, to: today)
//        let hours = calendar?.dateComponents([.hour], from: self, to: today)
//        let minutes = calendar?.dateComponents([.minute], from: self, to: today)
//        let seconds = calendar?.dateComponents([.second], from: self, to: today)
//        let dateComp = DateComponents(day: days?.day, hour: hours?.hour, minute: minutes?.minute, second: seconds?.second)
//        guard let elapsed = calendar?.date(from: dateComp) else { return "???" }
        formatter.timeStyle = .short
        let dateString = formatter.string(from: self)
        return dateString
    }
    
    
    /// Formats a Date object to just a standard american format with no time.
    /// - Returns: A string representation of the date format.
    public func kgDateFormatter(year: Bool = true, time: Bool = false) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        if year && time == false {
            formatter.setLocalizedDateFormatFromTemplate("MMM d, yyyy")
        } else if year && time {
            formatter.setLocalizedDateFormatFromTemplate("MMM d, yyyy - h:mm")
        } else if year == false && time {
            formatter.setLocalizedDateFormatFromTemplate("MMM d - h:mm")
        }
        return formatter.string(from: self)
    }
    
    
    /// Formats a Date object to a weekday. i.e "Monday"
    /// - Returns: A string representation of the date format.
    public var getCurrentWeekdayAsString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.setLocalizedDateFormatFromTemplate("EEEE")
        let weekday = formatter.string(from: self)
        return weekday
    }
    
    
    /// Formats a Date object to a day of the month. i.e "15" or "6"
    /// - Returns: A string representation of the date format.
    public var getCurrentDayNumAsString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.setLocalizedDateFormatFromTemplate("d")
        let day = formatter.string(from: self)
        return day
    }
    
    
    /// Adds the amount of days before/after "today".
    /// - Parameter days: 1 for tomorrow, 0 for today,  -1 for yesterday, etc.
    public func addToDate(by days: Int) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        var dayComponent = DateComponents()
        dayComponent.day = days
        guard let date = calendar.date(byAdding: dayComponent, to: self) else { return Date() }
        return date
    }
    
}


// MARK: DateInterval Extension
extension DateInterval {
    
    /// Formats a DateInterval object to just a standard american format with no time.
    /// - Returns: A string representation of the dateInterval formated.
    public var kgDateIntervalFormatter: String {
        let formatter = DateIntervalFormatter()
        formatter.locale = Locale.current
        
        // Configure Date Interval Formatter
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        // String From Date Interval
        guard let str = formatter.string(from: self) else { return "???" }
        
        return str
    }
    
    
}


// MARK: View Extension
extension View {
    
    func placeHolder<T:View>(_ holder: T, show: Bool, color: Color = .gray, alignment: Alignment = .leading) -> some View {
        self.modifier(PlaceHolder(placeHolder: holder, show: show, color: color, alignment: alignment))
    }
}


// MARK: UIColor Extension
extension UIColor {

    // MARK: - Initialization

    convenience init?(hex: String) {
        var hexNormalized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexNormalized = hexNormalized.replacingOccurrences(of: "#", with: "")

        // Helpers
        var rgb: UInt64 = 0
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        let length = hexNormalized.count

        // Create Scanner
        Scanner(string: hexNormalized).scanHexInt64(&rgb)

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, alpha: a)
    }


    var toHex: String? {
        // Extract Components
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }

        // Helpers
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count >= 4 {
            a = Float(components[3])
        }

        // Create Hex String
        let hex = String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))

        return hex
    }

}


// MARK: UINavigationController Extension
extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()

        let navBar = UINavigationBarAppearance()
        navBar.backgroundColor = UIColor(ColorManager.secondDark)
        navBar.titleTextAttributes = [.foregroundColor: UIColor(.white)]
        navBar.largeTitleTextAttributes = [.foregroundColor: UIColor(.white)]

        navigationBar.standardAppearance = navBar
        navigationBar.compactAppearance = navBar
//        navigationBar.scrollEdgeAppearance = navBarBackgroundColor

    }
}


// MARK: UISegmentedControl Extensions
extension UISegmentedControl {
    override open func setNeedsDisplay() {
        let segCont = UISegmentedControl.appearance()
        segCont.selectedSegmentTintColor = UIColor(ColorManager.lightPink)
        segCont.backgroundColor = UIColor.gray
        segCont.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        segCont.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        
    }
    
}


extension UITableViewController {
    
    override open func viewWillLayoutSubviews() {
        let appear = UITableView.appearance()
        
        let colors = [UIColor(ColorManager.secondDark).cgColor, UIColor(ColorManager.mainDark).cgColor]
        let gradientLocations: [NSNumber] = [0.0, 1.0]

        let gradientLayer = CAGradientLayer()
        gradientLayer .colors = colors
        gradientLayer.locations = gradientLocations
        gradientLayer.frame = self.tableView.frame
                
        appear.layer.addSublayer(gradientLayer)
    }
    
}





