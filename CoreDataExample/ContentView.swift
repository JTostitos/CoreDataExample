//
//  ContentView.swift
//  CoreDataExample
//
//

import SwiftUI
import CoreData
import Charts

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.focusDate, ascending: true)], animation: .default) private var items: FetchedResults<Item>
    @State private var date: Date = .now

    var body: some View {
        NavigationView {
            
            ScrollView {
                Chart {
                    ForEach(items) { item in
                        BarMark(
                            x: .value("Date", item.focusDate ?? Date(), unit: .day),
                            y: .value("Focus Session", item.focusSession)
                        )
                        .foregroundStyle(Color.pink.gradient)
                        .cornerRadius(12)
                        .annotation(position: .overlay) {
                            Text("\(item.focusSession)")
                        }
                    }
                }
                .frame(height: 300)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    DatePicker("Pick Date", selection: $date, displayedComponents: .date)
                        .datePickerStyle(.compact)
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.focusDate = date
            newItem.focusSession = Int16(Int.random(in: 1...20)) //Assign newItem.focusSession to the variable that stores how many focusSessions were completed in this day. Int.random() is here for demonstration purposes.

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
