//
//  HomeView.swift
//  consumer-app
//
//  Created by UTTAM KUMAR DEY on 08/11/25.
//

import SwiftUI

struct HomeView: View {
    @Environment(AppRouter.self) var appRouter
    @Bindable var viewModel: HomeViewModel
    @State private var loadTask: Task<Void, Never>?
    var body: some View {
        VStack {
            PrimaryButton(title: "Primary Button", action: {
                retainCycle()
                
                //            loadTask = Task {
                //                    await viewModel.loadLanguages() // step 1:- View calls viewmodel
                //                }
                ////                appRouter.pop()
                //            }, isLoading: viewModel.isLoading)
                //            .padding(30)
            }
                          //        .errorAlert(error: $viewModel.error, onRetry:  {
                          //            Task {
                          //                await viewModel.loadLanguages()
                          //            }
                          //        }
                          
            )
            .onDisappear {
                
                loadTask?.cancel()
            }
        }
    }
    public func retainCycle() {
        var a: A? = A()
        var b: B? = B()
        
        // Step 1: Link both objects strongly
        a?.objB = b
        b?.objA = a
        
        // Step 2: Remove external references
        a = nil
        b = nil
        
    }
}

    public class A {
        var objB: B?
        deinit {
            print("A is deinitialized")
        }
    }
    public class B {
         var objA: A?
        deinit {
            print("B is deinitialized")
        }
    }
