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

package utils

import controllers.routes
import models.{CheckMode, UserAnswers}
import pages._
import viewmodels.{AnswerRow, RepeaterAnswerRow, RepeaterAnswerSection}

class CheckYourAnswersHelper(userAnswers: UserAnswers) {

  def isEoriForContactPerson: Option[AnswerRow] = userAnswers.get(IsEoriForContactPersonPage) map {
    x => AnswerRow("isEoriForContactPerson.checkYourAnswersLabel", if(x) "site.yes" else "site.no", true, routes.IsEoriForContactPersonController.onPageLoad(CheckMode).url)
  }

  def contactDetails: Option[AnswerRow] = userAnswers.get(ContactDetailsPage) map {
    x => AnswerRow("contactDetails.checkYourAnswersLabel", s"${x.name} ${x.email}", false, routes.ContactDetailsController.onPageLoad(CheckMode).url)
  }

  def applyingForSomeoneElse: Option[AnswerRow] = userAnswers.get(ApplyingForSomeoneElsePage) map {
    x => AnswerRow("applyingForSomeoneElse.checkYourAnswersLabel", if(x) "site.yes" else "site.no", true, routes.ApplyingForSomeoneElseController.onPageLoad(CheckMode).url)
  }
}
