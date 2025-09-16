# GestorUsuarios

Pequeña app iOS para **listar, crear, editar** y **eliminar lógicamente** usuarios. Incluye caché local, validaciones y soporte de ubicación.

## Stack
- iOS 15+, Swift 5.9+
- **SwiftUI + Combine**, arquitectura **MVVM + Coordinators**
- **Alamofire** (red), **RealmSwift** (persistencia)
- **CoreLocation / MapKit** (ubicación)
- i18n **ES/EN**

## Requisitos cubiertos
- **Lista** con búsqueda, estados **loading/error** y actualización reactiva.
- **Detalle** con edición de **nombre** y **email**.
- **Crear** usuario con **validaciones** y captura de **ubicación** (one-shot).
- **Eliminación lógica** (`isDeleted` en Realm).
- **Persistencia** local + observación de cambios (Realm → Publisher).
- Concurrencia moderna (`async/await`) y aislamiento **`@MainActor`**.

## Arquitectura (breve)
- **Repository (`UsersRepository`)**  
  - `refreshUsers()`, `create`, `update`, `logicalDelete`  
  - `usersPublisher()` y `userPublisher(id:)` para UI reactiva
- **ViewModels**: `UsersListViewModel`, `UserDetailViewModel`, `UserFormViewModel`
- **Coordinators**: `AppCoordinator`, `UsersCoordinator` (inyección y navegación)
- **Modelos**:
  - `APIUser` (Decodable, campos frágiles como opcionales)
  - `User` (Realm) y `UserUI` (struct para la UI)

## Decisiones clave
- **Realm + MainActor** para evitar “Realm accessed from incorrect thread”.
- El repo **lee y escribe** con la **misma instancia Realm** que observa (consistencia en notificaciones).
- **Dismiss seguro** tras crear/guardar (único disparo con `DispatchQueue.main.async`).
- Decodificación **tolerante**: campos faltantes como opcionales; logs claros de decode.

## Configuración
1. Crear proyecto Xcode (**App**, iOS 15+, SwiftUI).
2. Agregar SPM:
   - `https://github.com/Alamofire/Alamofire`
   - `https://github.com/realm/realm-swift`
3. **Info.plist**:
   - `NSLocationWhenInUseUsageDescription`
   - `NSLocationAlwaysAndWhenInUseUsageDescription`
4. Añadir carpeta `Project/App` al proyecto (Create groups).

## Ejecución
Selecciona un simulador iOS 15+ y **Run**.

## Tests
Desde Xcode: **Product → Test**  
CLI (tras crear esquema “UsersApp”):
```bash
xcodebuild -scheme UsersApp -destination 'platform=iOS Simulator,name=iPhone 15' test
