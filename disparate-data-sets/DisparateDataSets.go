package main

import (
    "bufio"
    "encoding/csv"
    "fmt"
    "os"
    "sort"
    "strings"
)

type Event struct {
    EventID       string
    Title         string
    Acronym       string
    ProjectCode   string
    ThreeDigitCode string
    RecordType    string
    ParentID      string
}

func (e Event) ToCSVString() string {
    fields := []string{
        e.EventID,
        fmt.Sprintf(`"%s"`, e.Title),
        fmt.Sprintf(`"%s"`, e.Acronym),
        e.ProjectCode,
        e.ThreeDigitCode,
        fmt.Sprintf(`"%s"`, e.RecordType),
    }
    if e.ParentID != "" {
        fields = append(fields, e.ParentID)
    }
    return strings.Join(fields, ",")
}

func processEvents(inputData string) string {
    var events []Event
    reader := csv.NewReader(strings.NewReader(inputData))
    rows, _ := reader.ReadAll()

    for _, row := range rows {
        event := Event{
            EventID:       row[0],
            Title:         strings.Trim(row[1], `"`),
            Acronym:       strings.Trim(row[2], `"`),
            ProjectCode:   row[3],
            ThreeDigitCode: row[4],
            RecordType:    strings.Trim(row[5], `"`),
        }
        events = append(events, event)
    }

    eventsByAcronym := make(map[string][]Event)
    for _, event := range events {
        if event.Acronym != "" {
            eventsByAcronym[event.Acronym] = append(eventsByAcronym[event.Acronym], event)
        }
    }

    var validSets []struct {
        Parent   Event
        Children []Event
    }

    for _, group := range eventsByAcronym {
        var parents, children []Event
        for _, e := range group {
            if e.RecordType == "Parent Event" {
                parents = append(parents, e)
            } else if e.RecordType == "IEEE Event" {
                children = append(children, e)
            }
        }

        if len(parents) != 1 || len(children) == 0 {
            continue
        }

        parent := parents[0]

        childCodes := make(map[string]struct{})
        for _, child := range children {
            if child.ThreeDigitCode != "" {
                childCodes[child.ThreeDigitCode] = struct{}{}
            }
        }

        if len(childCodes) > 1 {
            parent.ThreeDigitCode = "???"
        } else if len(childCodes) == 1 {
            for code := range childCodes {
                parent.ThreeDigitCode = code
            }
        }

        for i := range children {
            children[i].ParentID = parent.EventID
        }

        sort.Slice(children, func(i, j int) bool {
            if children[i].Title != children[j].Title {
                return children[i].Title < children[j].Title
            }
            return children[i].EventID < children[j].EventID
        })

        validSets = append(validSets, struct {
            Parent   Event
            Children []Event
        }{Parent: parent, Children: children})
    }

    sort.Slice(validSets, func(i, j int) bool {
        return validSets[i].Parent.Acronym < validSets[j].Parent.Acronym
    })

    var outputLines []string
    for _, set := range validSets {
        outputLines = append(outputLines, set.Parent.ToCSVString())
        for _, child := range set.Children {
            outputLines = append(outputLines, child.ToCSVString())
        }
    }

    return strings.Join(outputLines, "\n")
}

func main() {
    var inputLines []string
    scanner := bufio.NewScanner(os.Stdin)
    for scanner.Scan() {
        line := scanner.Text()
        if line == "" {
            break
        }
        inputLines = append(inputLines, line)
    }

    inputData := strings.Join(inputLines, "\n")
    result := processEvents(inputData)
    fmt.Println(result)
}