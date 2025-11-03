//
//  FoodEntryRepository.swift
//  Demeter
//
//  Created by Kilo Code
//  Generated from specs/002-app-infrastructure/plan.md
//

import SwiftData
import Foundation

/// Protocol defining the FoodEntry repository interface
protocol FoodEntryRepositoryProtocol {
    func create(_ entry: FoodEntry) async throws -> FoodEntry
    func fetch(byId id: UUID) async throws -> FoodEntry?
    func fetch(forDate date: Date) async throws -> [FoodEntry]
    func fetchToday() async throws -> [FoodEntry]
    func fetch(inRange range: ClosedRange<Date>) async throws -> [FoodEntry]
    func update(_ entry: FoodEntry) async throws
    func delete(_ entry: FoodEntry) async throws
    func deleteAll(forDate date: Date) async throws
}

/// SwiftData implementation of FoodEntryRepositoryProtocol
@MainActor
final class FoodEntryRepository: FoodEntryRepositoryProtocol {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    // MARK: - CRUD Operations

    func create(_ entry: FoodEntry) async throws -> FoodEntry {
        guard entry.isValid else {
            throw RepositoryError.validationError("Invalid FoodEntry data")
        }

        modelContext.insert(entry)
        try modelContext.save()
        return entry
    }

    func fetch(byId id: UUID) async throws -> FoodEntry? {
        let predicate = #Predicate<FoodEntry> { $0.id == id }
        let descriptor = FetchDescriptor<FoodEntry>(predicate: predicate)
        let results = try modelContext.fetch(descriptor)
        return results.first
    }

    func update(_ entry: FoodEntry) async throws {
        guard entry.isValid else {
            throw RepositoryError.validationError("Invalid FoodEntry data")
        }

        try modelContext.save()
    }

    func delete(_ entry: FoodEntry) async throws {
        modelContext.delete(entry)
        try modelContext.save()
    }

    // MARK: - Query Operations

    func fetchToday() async throws -> [FoodEntry] {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!

        return try await fetch(inRange: today...tomorrow)
    }

    func fetch(forDate date: Date) async throws -> [FoodEntry] {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!

        let predicate = #Predicate<FoodEntry> { entry in
            entry.timestamp >= startOfDay && entry.timestamp < endOfDay
        }

        let descriptor = FetchDescriptor<FoodEntry>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )

        return try modelContext.fetch(descriptor)
    }

    func fetch(inRange range: ClosedRange<Date>) async throws -> [FoodEntry] {
        let predicate = #Predicate<FoodEntry> { entry in
            entry.timestamp >= range.lowerBound && entry.timestamp < range.upperBound
        }

        let descriptor = FetchDescriptor<FoodEntry>(
            predicate: predicate,
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )

        return try modelContext.fetch(descriptor)
    }

    func deleteAll(forDate date: Date) async throws {
        let entries = try await fetch(forDate: date)
        for entry in entries {
            modelContext.delete(entry)
        }
        try modelContext.save()
    }
}

// MARK: - Error Types

public enum RepositoryError: Error {
    case validationError(String)
    case notFound(String)
    case persistenceError(String)
}