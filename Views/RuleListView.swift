import SwiftUI

struct RuleListView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        List {
            ForEach(appState.courses) { course in
                let courseRules = appState.rules.filter { $0.courseId == course.id }

                Section(course.name) {
                    ForEach(courseRules) { rule in
                        NavigationLink {
                            RuleMessageEditorView(ruleId: rule.id)
                        } label: {
                            RuleSummaryView(rule: rule)
                        }
                    }
                }
            }
        }
        .navigationTitle("Rule")
    }
}

private struct RuleSummaryView: View {
    let rule: HabitRule

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label(rule.placeCategory.displayName, systemImage: rule.placeCategory.systemImage)
                Spacer()
                Text(rule.triggerType.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Text(rule.message)
                .font(.subheadline)
                .lineLimit(3)

            HStack {
                Text(rule.timeBlock.displayName)
                Text(rule.weekdayType.displayName)
                Text(rule.isEnabled ? "ON" : "OFF")
            }
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

private struct RuleMessageEditorView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.dismiss) private var dismiss

    let ruleId: UUID
    @State private var message: String

    init(ruleId: UUID) {
        self.ruleId = ruleId
        _message = State(initialValue: "")
    }

    var body: some View {
        Group {
            if let rule = appState.rule(for: ruleId) {
                Form {
                    Section("条件") {
                        LabeledContent("場所", value: rule.placeCategory.displayName)
                        LabeledContent("トリガー", value: rule.triggerType.displayName)
                        LabeledContent("時間帯", value: rule.timeBlock.displayName)
                        LabeledContent("曜日", value: rule.weekdayType.displayName)
                        LabeledContent("状態", value: rule.isEnabled ? "ON" : "OFF")
                    }

                    Section {
                        TextEditor(text: $message)
                            .frame(minHeight: 140)

                        Button {
                            message = appState.presetRuleMessage(for: ruleId) ?? message
                        } label: {
                            Label("初期文に戻す", systemImage: "arrow.counterclockwise")
                        }
                    } header: {
                        Text("通知文")
                    } footer: {
                        Text("{place}は登録地点名、{category}はカテゴリ名に置き換わります。条件はMVPでは固定し、通知文だけ編集できます。")
                    }
                }
                .navigationTitle("通知文を編集")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("キャンセル") {
                            dismiss()
                        }
                    }

                    ToolbarItem(placement: .confirmationAction) {
                        Button("保存") {
                            appState.updateRuleMessage(ruleId: ruleId, message: trimmedMessage)
                            dismiss()
                        }
                        .disabled(trimmedMessage.isEmpty)
                    }
                }
                .onAppear {
                    message = rule.message
                }
            } else {
                ContentUnavailableView("ルールが見つかりません", systemImage: "list.bullet.rectangle")
            }
        }
    }

    private var trimmedMessage: String {
        message.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
