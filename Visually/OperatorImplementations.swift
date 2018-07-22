//
//  OperatorImplementations.swift
//  UIExtensions
//
//  Created by Łukasz Kasperek on 16.03.2018.
//  Copyright © 2018 AppUnite. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

public prefix func |- (parameters: ConstraintParameters) -> OpeningBuildPoint {
    return OpeningBuildPoint(parameters: parameters, relation: .equal)
}

public prefix func |- (bpc: BuildPointConvertible) -> BuildPoint {
    let (superview, view, constraints) = bpc.decomposeWithSuperview()
    let constraint: Constraint = { axis in
        switch axis {
        case .horizontal: return view.leadingAnchor.constraint(equalTo: superview.leadingAnchor)
        case .vertical: return view.topAnchor.constraint(equalTo: superview.topAnchor)
        }
    }
    return BuildPoint(constraints: constraints + [constraint], contrainable: view)
}

public prefix func |->= (parameters: ConstraintParameters) -> OpeningBuildPoint {
    return OpeningBuildPoint(parameters: parameters, relation: .greaterThanOrEqual)
}

public prefix func |-<= (parameters: ConstraintParameters) -> OpeningBuildPoint {
    return OpeningBuildPoint(parameters: parameters, relation: .lessThanOrEqual)
}

public prefix func |->=- (bpc: BuildPointConvertible) -> BuildPoint {
    let (superview, view, constraints) = bpc.decomposeWithSuperview()
    let constraint: Constraint = { axis in
        switch axis {
        case .horizontal: return view.leadingAnchor.constraint(greaterThanOrEqualTo: superview.leadingAnchor)
        case .vertical: return view.topAnchor.constraint(greaterThanOrEqualTo: superview.topAnchor)
        }
    }
    return BuildPoint(constraints: constraints + [constraint], contrainable: view)
}

public prefix func |-<=- (bpc: BuildPointConvertible) -> BuildPoint {
    let (superview, view, constraints) = bpc.decomposeWithSuperview()
    let constraint: Constraint = { axis in
        switch axis {
        case .horizontal: return view.leadingAnchor.constraint(lessThanOrEqualTo: superview.leadingAnchor)
        case .vertical: return view.topAnchor.constraint(lessThanOrEqualTo: superview.topAnchor)
        }
    }
    return BuildPoint(constraints: constraints + [constraint], contrainable: view)
}

public func - (lhs: BuildPointConvertible, rhs: BuildPointConvertible) -> BuildPoint {
    let (lView, lConstraints) = lhs.decompose()
    let (rView, rConstraints) = rhs.decompose()
    let constraint: Constraint = { axis in
        switch axis {
        case .horizontal: return rView.leadingAnchor.constraint(equalTo: lView.trailingAnchor)
        case .vertical: return rView.topAnchor.constraint(equalTo: lView.bottomAnchor)
        }
    }
    return BuildPoint(constraints: lConstraints + [constraint] + rConstraints, contrainable: rView)
}

public func - (lhs: OpeningBuildPoint, rhs: BuildPointConvertible) -> BuildPoint {
    let (superview, view, constraints) = rhs.decomposeWithSuperview()
    let constraint: Constraint = { axis in
        let c: NSLayoutConstraint = {
            switch (axis, lhs.relation) {
            case (.horizontal, .equal): return view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: lhs.parameters.constant)
            case (.horizontal, .greaterThanOrEqual): return view.leadingAnchor.constraint(greaterThanOrEqualTo: superview.leadingAnchor, constant: lhs.parameters.constant)
            case (.horizontal, .lessThanOrEqual): return view.leadingAnchor.constraint(lessThanOrEqualTo: superview.leadingAnchor, constant: lhs.parameters.constant)
            case (.vertical, .equal): return view.topAnchor.constraint(equalTo: superview.topAnchor, constant: lhs.parameters.constant)
            case (.vertical, .greaterThanOrEqual): return view.topAnchor.constraint(greaterThanOrEqualTo: superview.topAnchor, constant: lhs.parameters.constant)
            case (.vertical, .lessThanOrEqual): return view.topAnchor.constraint(lessThanOrEqualTo: superview.topAnchor, constant: lhs.parameters.constant)
            }
        }()
        c.priority = lhs.parameters.priority
        return c
    }
    return BuildPoint(constraints: constraints + [constraint], contrainable: view)
}

public func - (lhs: IntermediaryBuildPoint, rhs: BuildPointConvertible) -> BuildPoint {
    let (lView, lConstraints) = lhs.lastBuildPoint.decompose()
    let (rView, rConstraints) = rhs.decompose()
    let constraint: Constraint = { axis in
        let c: NSLayoutConstraint = {
            switch (axis, lhs.relation) {
            case (.horizontal, .equal): return rView.leadingAnchor.constraint(equalTo: lView.trailingAnchor, constant: lhs.parameters.constant)
            case (.horizontal, .greaterThanOrEqual): return rView.leadingAnchor.constraint(greaterThanOrEqualTo: lView.trailingAnchor, constant: lhs.parameters.constant)
            case (.horizontal, .lessThanOrEqual): return rView.leadingAnchor.constraint(lessThanOrEqualTo: lView.trailingAnchor, constant: lhs.parameters.constant)
            case (.vertical, .equal): return rView.topAnchor.constraint(equalTo: lView.bottomAnchor, constant: lhs.parameters.constant)
            case (.vertical, .greaterThanOrEqual): return rView.topAnchor.constraint(greaterThanOrEqualTo: lView.bottomAnchor, constant: lhs.parameters.constant)
            case (.vertical, .lessThanOrEqual): return rView.topAnchor.constraint(lessThanOrEqualTo: lView.bottomAnchor, constant: lhs.parameters.constant)
            }
        }()
        c.priority = lhs.parameters.priority
        return c
    }
    return BuildPoint(constraints: lConstraints + [constraint] + rConstraints, contrainable: rView)
}

public func - (lhs: BuildPointConvertible, rhs: ClosingBuildPoint) -> BuildPoint {
    let (superview, view, constraints) = lhs.decomposeWithSuperview()
    let constraint: Constraint = { axis in
        let c: NSLayoutConstraint = {
            switch axis {
            case .horizontal: return superview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: rhs.parameters.constant)
            case .vertical: return superview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: rhs.parameters.constant)
            }
        }()
        c.priority = rhs.parameters.priority
        return c
    }
    return BuildPoint(constraints: constraints + [constraint], contrainable: view)
}

public func ->=- (lhs: BuildPointConvertible, rhs: BuildPointConvertible) -> BuildPoint {
    let (lView, lConstraints) = lhs.decompose()
    let (rView, rConstraints) = rhs.decompose()
    let constraint: Constraint = { axis in
        switch axis {
        case .horizontal: return rView.leadingAnchor.constraint(greaterThanOrEqualTo: lView.trailingAnchor)
        case .vertical: return rView.topAnchor.constraint(greaterThanOrEqualTo: lView.bottomAnchor)
        }
    }
    return BuildPoint(constraints: lConstraints + [constraint] + rConstraints, contrainable: rView)
}

public func -<=- (lhs: BuildPointConvertible, rhs: BuildPointConvertible) -> BuildPoint {
    let (lView, lConstraints) = lhs.decompose()
    let (rView, rConstraints) = rhs.decompose()
    let constraint: Constraint = { axis in
        switch axis {
        case .horizontal: return rView.leadingAnchor.constraint(lessThanOrEqualTo: lView.trailingAnchor)
        case .vertical: return rView.topAnchor.constraint(lessThanOrEqualTo: lView.bottomAnchor)
        }
    }
    return BuildPoint(constraints: lConstraints + [constraint] + rConstraints, contrainable: rView)
}

public func - (lhs: BuildPointConvertible, rhs: ConstraintParameters) -> IntermediaryBuildPoint {
    return IntermediaryBuildPoint(lastBuildPoint: lhs.buildPoint(), parameters: rhs, relation: .equal)
}

public func ->= (lhs: BuildPointConvertible, rhs: ConstraintParameters) -> IntermediaryBuildPoint {
    return IntermediaryBuildPoint(lastBuildPoint: lhs.buildPoint(), parameters: rhs, relation: .greaterThanOrEqual)
}

public func -<= (lhs: BuildPointConvertible, rhs: ConstraintParameters) -> IntermediaryBuildPoint {
    return IntermediaryBuildPoint(lastBuildPoint: lhs.buildPoint(), parameters: rhs, relation: .lessThanOrEqual)
}

public func ->= (lhs: BuildPointConvertible, rhs: ClosingBuildPoint) -> BuildPoint {
    let (superview, view, constraints) = lhs.decomposeWithSuperview()
    let constraint: Constraint = { axis in
        let c: NSLayoutConstraint = {
            switch axis {
            case .horizontal: return superview.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor, constant: rhs.parameters.constant)
            case .vertical: return superview.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor, constant: rhs.parameters.constant)
            }
        }()
        c.priority = rhs.parameters.priority
        return c
    }
    return BuildPoint(constraints: constraints + [constraint], contrainable: view)
}

public func -<= (lhs: BuildPoint, rhs: ClosingBuildPoint) -> BuildPoint {
    let (superview, view, constraints) = lhs.decomposeWithSuperview()
    let constraint: Constraint = { axis in
        let c: NSLayoutConstraint = {
            switch axis {
            case .horizontal: return superview.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: rhs.parameters.constant)
            case .vertical: return superview.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: rhs.parameters.constant)
            }
        }()
        c.priority = rhs.parameters.priority
        return c
    }
    return BuildPoint(constraints: constraints + [constraint], contrainable: view)
}

public postfix func -| (lhs: ConstraintParameters) -> ClosingBuildPoint {
    return ClosingBuildPoint(parameters: lhs)
}

public postfix func -| (lhs: BuildPointConvertible) -> BuildPoint {
    let (superview, view, constraints) = lhs.decomposeWithSuperview()
    let constraint: Constraint = { axis in
        switch axis {
        case .horizontal: return superview.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        case .vertical: return superview.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        }
    }
    return BuildPoint(constraints: constraints + [constraint], contrainable: view)
}

public postfix func ->=-| (lhs: BuildPointConvertible) -> BuildPoint {
    let (superview, view, constraints) = lhs.decomposeWithSuperview()
    let constraint: Constraint = { axis in
        switch axis {
        case .horizontal: return superview.trailingAnchor.constraint(greaterThanOrEqualTo: view.trailingAnchor)
        case .vertical: return superview.bottomAnchor.constraint(greaterThanOrEqualTo: view.bottomAnchor)
        }
    }
    return BuildPoint(constraints: constraints + [constraint], contrainable: view)
}

public postfix func -<=-| (lhs: BuildPointConvertible) -> BuildPoint {
    let (superview, view, constraints) = lhs.decomposeWithSuperview()
    let constraint: Constraint = { axis in
        switch axis {
        case .horizontal: return superview.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor)
        case .vertical: return superview.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor)
        }
    }
    return BuildPoint(constraints: constraints + [constraint], contrainable: view)
}

public prefix func >= (lhs: ConstraintParameters) -> SizeBuildPoint {
    return SizeBuildPoint(parameters: lhs, relation: .greaterThanOrEqual)
}

public prefix func <= (lhs: ConstraintParameters) -> SizeBuildPoint {
    return SizeBuildPoint(parameters: lhs, relation: .lessThanOrEqual)
}

public func ~ (lhs: CGFloat, rhs: LayoutPriority) -> ConstraintParameters {
    return ConstraintParameters(constant: lhs, priority: rhs)
}

private extension BuildPointConvertible {
    func decompose() -> (Constrainable, [Constraint]) {
        let bp = buildPoint()
        return (bp.contrainable, bp.constraints)
    }
    
    func decomposeWithSuperview() -> (View, Constrainable, [Constraint]) {
        let (view, constraints) = decompose()
        guard let superview = view.superview else {
            throwMissingSuperviewException()
        }
        return (superview, view, constraints)
    }
}

private func throwMissingSuperviewException() -> Never {
    fatalError("Attempt to pin view to superview, while it doesn't have one.")
}
