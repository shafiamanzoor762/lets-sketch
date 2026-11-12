//
//  DrawingScreenView.swift
//  lets-sketch
//
//  Created by Shafia Manzoor on 19/06/2026.

import SwiftUI
import SwiftData
import Domain
import Data
import CustomViews
import Router

public struct DrawingScreenView: View {

    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel: CanvasViewModel
    @State private var saveSelect = false
    @State private var openNew = false
    @FocusState private var titleFocused: Bool

    private let isEditingExisting: Bool

    public init(viewModel: CanvasViewModel, isEditingExisting: Bool = false) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.isEditingExisting = isEditingExisting
    }

    public var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                CustomTextField(placeholder: AppStrings.untitledSketch, text: $viewModel.title)
                    .focused($titleFocused)
                    .padding(.horizontal, AppTheme.spacing)
                    .padding(.top, 8)
                CustomButton(icon: "plus", style: .icon) {
                    openNew = true
                }
                .padding(.horizontal, AppTheme.spacing)
            }

            PencilCanvasRepresentable(viewModel: viewModel)
                .background(AppTheme.canvasSurface)
                .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadius))
                .overlay {
                    RoundedRectangle(cornerRadius: AppTheme.cornerRadius)
                        .stroke(AppTheme.lavender.opacity(0.7), lineWidth: 1)
                }
                .padding(.horizontal, AppTheme.spacing)
                .padding(.bottom, AppTheme.spacing)
        }
        .background(AppTheme.background.ignoresSafeArea())
        .navigationTitle(isEditingExisting ? AppStrings.editSketch : AppStrings.newSketch)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                CustomButton(icon: "arrow.uturn.backward", style: .icon, isDisabled: !viewModel.canUndo) {
                    viewModel.undo()
                }
                CustomButton(icon: "arrow.uturn.forward", style: .icon, isDisabled: !viewModel.canRedo) {
                    viewModel.redo()
                }
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if !isEditingExisting {
                    NavigationLink(value: AppRoute.gallery) {
                        Image(systemName: "square.grid.2x2")
                            .foregroundColor(AppTheme.deepPurple)
                    }
                }
                CustomButton(title: AppStrings.save, icon: "checkmark") {
                    saveSelect = viewModel.save(context: modelContext)
                }
            }
        }
        .onTapGesture {
            titleFocused = false
        }
        .alert(AppStrings.sketchSaved, isPresented: $saveSelect) {
            Button(AppStrings.confirm, role: .cancel) {}
        }
        .alert(AppStrings.saveSketchQuestion, isPresented: $openNew) {
            if #available(iOS 26.0, *) {
                Button(AppStrings.save, role: .confirm) {
                    saveSelect = viewModel.save(context: modelContext)
                }
            } else {
                // Fallback on earlier versions
            }
            if #available(iOS 26.0, *) {
                Button(AppStrings.discard, role: .close) {
                    viewModel.resetCanvas()
                }
            } else {
                // Fallback on earlier versions
            }
        }
        .onChange(of: titleFocused) { _, isFocused in
            if !isFocused {
                viewModel.activateCanvas()
            }
        }
    }
}
