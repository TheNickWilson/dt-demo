/*
 * Copyright 2018 HM Revenue & Customs
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package navigation

import javax.inject.{Inject, Singleton}

import play.api.mvc.Call
import controllers.routes
import pages._
import models._

@Singleton
class Navigator @Inject()() {

  private val routeMap: Map[Page, UserAnswers => Call] = Map(
    IsEoriForContactPersonPage -> isEoriRoute,
    ContactDetailsPage -> (_ => routes.ApplyingForSomeoneElseController.onPageLoad(NormalMode)),
    ApplyingForSomeoneElsePage -> (_ => routes.CheckYourAnswersController.onPageLoad())
  )

  private def isEoriRoute(answers: UserAnswers): Call = answers.get(IsEoriForContactPersonPage) match {
    case Some(true) => routes.ApplyingForSomeoneElseController.onPageLoad(NormalMode)
    case Some(false) => routes.ContactDetailsController.onPageLoad(NormalMode)
    case None => routes.SessionExpiredController.onPageLoad()
  }

  private val checkRouteMap: Map[Page, UserAnswers => Call] = Map(

  )

  def nextPage(page: Page, mode: Mode): UserAnswers => Call = mode match {
    case NormalMode =>
      routeMap.getOrElse(page, _ => routes.IndexController.onPageLoad())
    case CheckMode =>
      checkRouteMap.getOrElse(page, _ => routes.CheckYourAnswersController.onPageLoad())
  }
}
